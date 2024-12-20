import argparse
from read_metadata import readMetadata
import re
import subprocess



def get_contributors(dir=".", filter_usernames=["NotXia"]):
    contributors = {}
    regex_gh_noreply1 = re.compile(r"\s*(?P<commits>\d+)\s+(?P<fullname>.+) <(?P<email>\d+\+(?P<username>.+)@users\.noreply\.github\.com)>")
    regex_gh_noreply2 = re.compile(r"\s*(?P<commits>\d+)\s+(?P<fullname>.+) <(?P<email>(?P<username>.+)@users\.noreply\.github\.com)>")
    regex_fallback = re.compile(r"\s*(?P<commits>\d+)\s+(?P<fullname>.+) <(?P<email>.+@.+\.\w+)>")

    p1 = subprocess.Popen(["git", "log"], stdout=subprocess.PIPE)
    p2 = subprocess.Popen(["git", "shortlog", "-n", "-s", "-e"], stdin=p1.stdout, stdout=subprocess.PIPE)
    result = p2.communicate()[0].decode("utf-8").strip()

    if len(result) == 0: return []

    for l in result.split("\n"):
        if ((res := regex_gh_noreply1.search(l)) != None) or ((res := regex_gh_noreply2.search(l)) != None):
            email = res.group("email")
            username = res.group("username")
            fullname = res.group("fullname")
            commits = int(res.group("commits"))
        elif (res := regex_fallback.search(l)) != None:
            email = res.group("email")
            username = None
            fullname = res.group("fullname")
            commits = int(res.group("commits"))

        if username in filter_usernames:
            continue
        
        if email not in contributors: 
            contributors[email] = {
                "gh_username": None,
                "fullnames": [],
                "commits": 0,
            }
        contributors[email]["gh_username"] = username
        contributors[email]["fullnames"].append(fullname)
        contributors[email]["commits"] += commits

    contributors = list(contributors.values())
    contributors.sort(key=lambda x: x["commits"], reverse=True)
    return contributors


if __name__ == "__main__":
    parser = argparse.ArgumentParser(prog="README updater")
    parser.add_argument("--src-path", type=str, required=True, help="Path to the .tex sources")
    parser.add_argument("--readme-path", type=str, required=True, help="Path to the readme")
    parser.add_argument("--gh-link", type=str, required=True, help="Link to the GitHub repo")
    args = parser.parse_args()


    # Adds contributors to README
    contributors = get_contributors(args.src_path)
    with open(args.readme_path, "a") as readme_f:
        readme_f.write(f"\n\n## Contributors\n")
        readme_f.write(f"Special thanks to: ")
        contributors_strs = []
        for i in range(len(contributors)):
            if contributors[i]["gh_username"] is not None:
                contributors_strs.append(f"[{contributors[i]['gh_username']}](https://github.com/{contributors[i]['gh_username']})")
            elif len(contributors[i]["fullnames"]) > 0:
                contributors_strs.append(f"{contributors[i]['fullnames'][-1]}")
        readme_f.write(", ".join(contributors_strs))


    # Adds ToC to README
    notes_metadata = readMetadata(args.src_path, args.gh_link)
    with open(args.readme_path, "a") as readme_f:
        readme_f.write(f"\n\n## Table of contents\n")
        for year in sorted(notes_metadata.keys()):
            readme_f.write(f"\n### Year {year}\n")

            for semester in sorted(notes_metadata[year].keys()):
                for course in sorted(notes_metadata[year][semester]):
                    course_name = notes_metadata[year][semester][course]["name"]
                    course_content = notes_metadata[year][semester][course]["content"]

                    if (len(course_content) == 1) and (course_content[0]["name"] is None):
                        readme_f.write(f"- [**{course_name}**]({course_content[0]['url']})\n")
                    else:
                        readme_f.write(f"- **{course_name}**\n")
                        for content in course_content:
                            readme_f.write(f"   - [{content['name']}]({content['url']})\n")
