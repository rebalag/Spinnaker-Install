#!/usr/bin/env python2
'''
The MIT License
Copyright (c) 2018 OpsMx
'''

__author__ = "OpsMx"
__license__ = "The MIT License"
__version__ = "2.0"
__maintainer__ = "OpsMx"

import sys
import subprocess


DOCKER_PULL = "docker pull {}"
DOCKER_TAG = "docker tag {} {}" 
DOCKER_PUSH = "docker push {}"  

OPSMX_REPO = "docker.io/opsmx11/{}:{}"
dest_repo = "{}/{}:{}"


artifacts_version = {
    "deck": "2.6.1-20181220153244",
    "gate": "1.4.0-20181217192627",
    "front50": "0.14.0-20181207134351",
    "fiat": "1.3.0-20181207134351",
    "echo": "2.2.2-20181219133919",
    "igor": "1.0.0-20181207134351",
    "rosco": "0.8.2-20181221095200",
    "orca": "2.0.1-20181220142907",
    "clouddriver": "4.2.0-20181220153244",
    "kayenta": "0.5.0-20181207134351",
    "redis": "v3",
    "halyard":"stable"
}

def execute(cmd, verbose=False):
    p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out = []
    while True:
        line = p.stdout.readline()
        out.append(line)
        if verbose:
            print line,
        if not line and p.poll() is not None:
            break
    if p.returncode != 0:
        print p.stderr.read().strip()
        return 1
    else:
        return ''.join(out).strip()
    
def pullPush(userName):
    for name, version in artifacts_version.items():
        dest_repo = "{}/{}:{}".format(userName, name, version)
        image_name = OPSMX_REPO.format(name, version)
        print "[*] Downloading {} docker container".format(image_name)
        execute(DOCKER_PULL.format(image_name), True)
        print "   [*] Tagging the image as {}".format(dest_repo)
        execute(DOCKER_TAG.format(image_name, dest_repo))
        print "    [*] Pushing {}".format(dest_repo)
        execute(DOCKER_PUSH.format(dest_repo), True)


def main(argv):
    pullPush(argv[1])

if __name__ == '__main__':
main(sys.argv)
