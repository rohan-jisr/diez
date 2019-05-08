import {cleanupMockCommandData, cleanupMockOsData, mockExec, mockOsData} from '@diez/test-utils';
import {locateFont} from '../src/typography';

jest.mock('os');
jest.mock('@diez/cli-core');

afterEach(() => {
  cleanupMockCommandData();
  cleanupMockOsData();
});

describe('typography', () => {
  test('macOS font location', async () => {
    mockOsData.platform = 'darwin';
    mockExec.mockResolvedValue(JSON.stringify([]));
    expect(await locateFont('', {})).toBeUndefined();

    const nullFont = {name: '', style: '', path: ''};
    mockExec.mockResolvedValue(JSON.stringify([nullFont]));
    expect(await locateFont('nil', {style: 'normal'})).toEqual(nullFont);
    expect(await locateFont('nil', {style: 'italic'})).toEqual(nullFont);

    mockExec.mockResolvedValue(JSON.stringify([
      {
        name : 'Poppins-Regular',
        style : 'Regular',
        path : '\/path\/to\/Poppins-Regular.ttf',
      },
      {
        name : 'Poppins-Italic',
        style : 'Italic',
        path : '\/path\/to\/Poppins-Italic.ttf',
      },
    ]));

    expect(await locateFont('', {style: 'italic'})).toEqual({
      name: 'Poppins-Italic',
      path: '/path/to/Poppins-Italic.ttf',
      style: 'Italic',
    });

    expect(await locateFont('', {style: 'normal'})).toEqual({
      name: 'Poppins-Regular',
      path: '/path/to/Poppins-Regular.ttf',
      style: 'Regular',
    });

    expect(await locateFont('', {name: 'Poppins-Regular'})).toEqual({
      name: 'Poppins-Regular',
      path: '/path/to/Poppins-Regular.ttf',
      style: 'Regular',
    });

    expect(await locateFont('', {name: 'Poppins-Nonexistent'})).toEqual({
      name: 'Poppins-Regular',
      path: '/path/to/Poppins-Regular.ttf',
      style: 'Regular',
    });

    // Trigger cache lookup.
    expect(await locateFont('', {name: 'Poppins-Nonexistent'})).toEqual({
      name: 'Poppins-Regular',
      path: '/path/to/Poppins-Regular.ttf',
      style: 'Regular',
    });
  });

  test('non-macOS font location', async () => {
    mockOsData.platform = 'linux';
    expect(await locateFont('', {})).toBeUndefined();
  });
});
