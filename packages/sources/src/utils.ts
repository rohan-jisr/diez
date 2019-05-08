import {execAsync, info, isMacOS, warning} from '@diez/cli-core';
import {emptyDir, mkdirp, readFile, writeFile} from 'fs-extra';
import {walkSync} from 'fs-walk';
import {tmpdir} from 'os';
import {extname, join} from 'path';
import {PNG} from 'pngjs';
import {v4} from 'uuid';
import {FolderGroup, ImageFormats, Reporters} from './api';

const reservedCharReplacement = '-';
const filenameReservedRegExp = /[<>:"\/\\|?*\x00-\x1F]/g;
const windowsNamesReservedRegExp = /^(con|prn|aux|nul|com[0-9]|lpt[0-9])$/i;
const base64BitMapRegExp = /"data:image\/(png|jpe?g|gif);base64,(.*?)"/gi;

/**
 * Splits an array into chunks of `chunkSize` elements.
 * @ignore
 */
export const chunk = <T>(arr: T[], chunkSize: number) => {
  const temp = arr.slice(0);
  const results = [];

  while (temp.length) {
    results.push(temp.splice(0, chunkSize));
  }

  return results;
};

/**
 * Locate a binary on macOS.
 * @ignore
 */
export const locateBinaryMacOS = async (bundleId: string) => {
  if (!isMacOS()) {
    throw new Error('Platform is not macOS');
  }

  return await execAsync(`mdfind kMDItemCFBundleIdentifier=${bundleId}`);
};

/**
 * Empties `basePath` and creates the provided `folders` inside.
 * @ignore
 */
export const createFolders = async (basePath: string, folders: FolderGroup) => {
  await emptyDir(basePath);
  return Promise.all([
    Array.from(folders).map(async ([_, folder]) => mkdirp(join(basePath, folder))),
  ]);
};

/**
 * Escapes a command to be safe for shell usage.
 * @todo - Move this to @diez/cli-core.
 */
export const escapeShell = (cmd: string) => {
  return cmd.replace(/(["\s'$`\\])/g, '\\$1');
};

/**
 * Sanitizes a file name.
 */
export const sanitizeFileName = (name: string) => {
  if (typeof name !== 'string') {
    return '';
  }

  return name
    .replace(filenameReservedRegExp, reservedCharReplacement)
    .replace(windowsNamesReservedRegExp, reservedCharReplacement);
};

/**
 * Adjusts gamma of PNG files to make them look consistent across browsers.
 */
export const adjustImageGamma = (base64data: string, imageFormat: ImageFormats) => {
  if (imageFormat === ImageFormats.png && typeof base64data === 'string' && base64data.length) {
    try {
      const imageBufferData = Buffer.from(base64data, 'base64');
      const pngInstance = PNG.sync.read(imageBufferData);

      // 1/2.2 is a magic value found empirically after testing different values.
      pngInstance.gamma = 1 / 2.2;

      PNG.adjustGamma(pngInstance);
      const updatedBufferData = PNG.sync.write(pngInstance);
      return updatedBufferData.toString('base64');
    } catch (e) {
      return base64data;
    }
  }

  return base64data;
};

/**
 * Generates a random file name and path in the OS temporary directory.
 * @ignore
 */
export const generateRandomFilePath = (extension = '') => {
  const fileName = `${v4()}.${extension}`;
  return join(tmpdir(), fileName);
};

/**
 * Fixes the gamma values of SVGs in a directory.
 */
export const fixGammaOfSVGs = (directory: string) => {
  walkSync(directory, async (basedir, filename, stats) => {
    if (!stats.isFile() || extname(filename) !== `.${ImageFormats.svg}`) {
      return;
    }

    const qualifiedFilename = join(basedir, filename);
    const outputContents = (await readFile(qualifiedFilename)).toString();
    const updatedContents = outputContents.replace(base64BitMapRegExp, (matchString, imageFormat, base64data) => {
      return matchString.replace(
        base64data,
        adjustImageGamma(base64data, imageFormat),
      );
    });

    await writeFile(qualifiedFilename, updatedContents);
  });
};

/**
 * Reporters singleton used by exporters.
 * @ignore
 */
export const cliReporters: Reporters = {
  progress: info,
  error: warning,
};
