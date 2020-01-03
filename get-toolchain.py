#!/usr/bin/python

from __future__ import print_function

import hashlib
import json
import os
import sys
import tarfile

if sys.version_info.major == 2:
    from urllib import urlretrieve
elif sys.version_info.major == 3:
    from urllib.request import urlretrieve
else:
    sys.stderr.write("Unknown Python version")
    sys.exit(1)


def platform():
    if 'linux' in sys.platform:
        return 'linux'
    elif 'win' in sys.platform:
        return 'windows'
    else:
        return sys.platform


def reporthook(chunk, chunk_size, total_size):
    # Be quiet on travis.
    if os.environ.get('CI', False):
        return
    download_size = min(total_size, chunk * chunk_size)
    print("Downloaded", download_size, "of", total_size, "%.2f%%" % (download_size*1.0/total_size*100.0))


def download_files(toolchain_data):
    plat = platform()
    print("Platform:", plat)
    to_download = []
    for asset in toolchain_data['assets']:
        if plat not in asset['name']:
            continue
        to_download.append((asset['name'], asset['browser_download_url'], asset['size']))

    for filename, url, size in to_download:
        if "sha" in filename and "sha1" not in filename:
            continue
        if os.path.exists(filename):
            continue
        print("Downloading", url, "into", filename)
        urlretrieve(url, filename, reporthook=reporthook)
    return to_download


def check_files(to_download):
    sumfile = [f for f, u, s in to_download if f.endswith('sha1')][0]
    print("Checksum file", sumfile)
    sumfile_lines = [l.split() for l in open(sumfile, 'r').read().strip().splitlines()]
    print(sumfile_lines)

    error = False
    for wanted_checksum, path in sumfile_lines:
        filename = os.path.basename(path)

        hasher = hashlib.sha1()
        with open(filename, 'r') as f:
            while True:
                data = f.read(4096)
                if not data:
                    break
                hasher.update(data)

        actual_checksum = hasher.hexdigest()

        if wanted_checksum != actual_checksum:
            print(
                filename, "removed broken file,",
                "wanted checksum:", wanted_checksum,
                "actual checksum:", actual_checksum,
            )
            os.unlink(filename)
            error = True
        else:
            print(
                filename, "good file,",
                "matching checksum:", actual_checksum,
            )
    return not error


TOOLCHAIN = "https://api.github.com/repos/im-tomu/fomu-toolchain/releases/latest"


def get_toolchain_data():
    from urllib2 import urlopen, Request

    request = Request(TOOLCHAIN)

    token = os.environ.get('GH_TOKEN', None)
    if token:
        request.add_header('Authorization', 'token %s' % token)

    response = urlopen(request)
    return json.loads(response.read())


def main(argv):
    toolchain_data = get_toolchain_data()
    if 'assets' not in toolchain_data:
        import pprint
        pprint.pprint(toolchain_data)

    to_download = None
    while True:
        to_download = download_files(toolchain_data)
        if check_files(to_download):
            break
    assert to_download

    tarball = [f for f, u, s in to_download if f.endswith('.tar.gz')]
    print(tarball)
    assert len(tarball) == 1, tarball
    tarball = tarball[0]

    with tarfile.open(tarball) as tar:
        tar.extractall()

    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
