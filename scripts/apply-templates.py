#! /usr/bin/env python

# Helper script that recurses over a directory tree, copying or transforming files based on their name and based on arguments.

from __future__ import absolute_import, print_function, unicode_literals

import shutil
import os
import argparse

from jinja2 import Template

def main():

    parser = argparse.ArgumentParser(description='Copy / transform files recursively from source to target directory.')
    parser.add_argument('sourceroot',
                        help='where to start recursion')
    parser.add_argument('targetroot',
                        help='where to put files recursion')
    parser.add_argument('--filenum',
                        default=1,
                        type=int,
                        help='how many template clones to create')
    parser.add_argument('--subprojectnum',
                        default=1,
                        type=int,
                        help='how many file clones to create')

    args = parser.parse_args()

    if not os.path.exists(args.targetroot):
            os.makedirs(args.targetroot)

    for file in all_files(args.sourceroot):
        transformFile(file,
                      args.sourceroot,
                      args.targetroot,
                      args.subprojectnum,
                      args.filenum)


def transformFile(file, sourceroot, targetroot, subprojectnum, filenum):
    relpath = os.path.relpath(file, sourceroot)
    target_dir = os.path.join(targetroot, os.path.dirname(relpath))
    params = {'subprojectnum': subprojectnum,
              'filenum': filenum,
              'index': '',
              'proindex': ''
          }
    if (target_dir.find('PROINDEX') >= 0):
        for proindex in range(0, subprojectnum):
            params['proindex'] = proindex
            loop_target_dir = target_dir.replace('PROINDEX', "%s" % proindex)
            transformFileFixedDir(file, relpath, loop_target_dir, filenum, params)
    else:
        transformFileFixedDir(file, relpath, target_dir, filenum, params)

def transformFileFixedDir(file, relpath, target_dir, filenum, params):
    if target_dir and not os.path.exists(target_dir):
        os.makedirs(target_dir)
    if file.endswith('.tmpl'):
        applyTemplate(file, relpath, target_dir, params)
    elif file.endswith('.looptmpl'):
        repeatTemplate(file, relpath, target_dir, filenum, params)
    else:
        filename = os.path.basename(relpath)
        shutil.copyfile(file, os.path.join(target_dir, filename))

def repeatTemplate(file, relpath, target_dir, filenum, params):
    for index in range(0, filenum):
        params['index'] = index
        applyTemplate(file, relpath, target_dir,params)

def applyTemplate(file, relpath, target_dir, params):
    filename = os.path.basename(relpath)
    # cut off extension
    filename = filename[:filename.rfind('.')]
    with open(file, 'r') as filehandle:
        template = Template(filehandle.read())
        content = template.render(params)
    target_file = os.path.join(target_dir, filename.replace('INDEX', "%s" % params['index']))

    with open(target_file, 'w') as filehandle:
        filehandle.write(content)

def all_files(directory):
    for path, dirs, files in os.walk(directory):
        if '.svn' in dirs:
            dirs.remove('.svn')
        if '.git' in dirs:
            dirs.remove('.git')
        for f in files:
            if not f.endswith('~'):
                yield os.path.join(path, f)


if __name__ == '__main__':
    main()
