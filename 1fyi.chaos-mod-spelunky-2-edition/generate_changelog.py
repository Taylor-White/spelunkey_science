import argparse
import os

argparser = argparse.ArgumentParser()
argparser.add_argument("file", help="the changelog file to write to")
argparser.add_argument("--version", help="the version of the changelog's program")
args = argparser.parse_args()

desc_start = "--- "

name_start = "module[\""
name_end = "\"]"

version_indicator = "--v "
version = args.version

if not os.path.exists("changelog.txt"): 
    with open("changelog.txt", "w") as f: f.write("")

new_stuff = dict[str, str]()

changelog_file = f"{version}:\n\tadded events:"

with open(args.file) as f:
    lines = f.readlines()
    for i, line in enumerate(lines):
        if line.startswith(name_start):
            line = line.replace(name_start, "")
            remove_index = line.index(name_end)
            name = line[:remove_index]
            new_stuff[name] = ""
            num = i - 1
            if lines[num].startswith(desc_start): 
                desc = lines[i - 1].replace(desc_start, "")
                new_stuff[name] = desc.replace("\n", "")
        elif line.startswith(version_indicator):
            line = line.replace(version_indicator, "v")
            new_stuff[line.replace("\n", "")] = ""

with open("changelog.txt", "w") as f:
    for item in new_stuff.items():
        print(item)
        if item[0].startswith("v"):
            f.write(item[0] + ":\n")
        else:
            f.write("\t" + item[0] + ": " + item[1] + "\n")