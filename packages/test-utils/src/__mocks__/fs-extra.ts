import {sep} from 'path';
// @ts-ignore
import {WritableMock} from 'stream-mock';
import {mockFileSystem} from '../utils';

export const writeFile = (fullPath: string, content: string) => {
  mockFileSystem[fullPath] = content;
};

export const readFile = (fullPath: string) => {
  if (!pathExists(fullPath)) {
    throw new Error('File does not exist');
  }

  return mockFileSystem[fullPath];
};

export const emptyDir = (dirpath: string) => {
  Object.keys(mockFileSystem).forEach((dir) => {
    if (dir.startsWith(dirpath)) {
      delete mockFileSystem[dir];
    }
  });

  mockFileSystem[dirpath] = 'FOLDER';
};

export const removeSync = (path: string) => {
  emptyDir(path);
  delete mockFileSystem[path];
};

export const mkdirp = (dirpath: string) => {
  const segments = dirpath.slice(1).split('/');
  let dirCursor = dirpath[0];
  for (let i = 0; i < segments.length;) {
    dirCursor += segments[i];
    if (pathExists(dirCursor) && mockFileSystem[dirCursor] !== 'FOLDER') {
      throw new Error('mkdirp encountered a file');
    }
    mockFileSystem[dirCursor] = 'FOLDER';
    if (++i < segments.length) {
      dirCursor += sep;
    }
  }
};

export const pathExists = (path: string) => mockFileSystem[path] !== undefined;

export const unlink = (path: string, callback: () => void) => {
  delete mockFileSystem[path];
  setImmediate(callback);
  return true;
};

export const createWriteStream = (out: string) => {
  const stream = new WritableMock();
  stream.close = () => {
    writeFile(out, 'mockcontent');
  };
  return stream;
};

export const readJson = (path: string) => JSON.parse(mockFileSystem[path] as string);

export const writeJson = (path: string, content: any) => {
  writeFile(path, JSON.stringify(content));
};

export default jest.genMockFromModule('fs-extra');
