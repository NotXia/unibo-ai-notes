import argparse
import os
import pathlib
import json

METADATA_FILENAME = "metadata.json"


if __name__ == "__main__":
    parser = argparse.ArgumentParser(prog="README updater")
    parser.add_argument("--src-path", type=str, required=True, help="Path to the .tex sources")
    parser.add_argument("--readme-path", type=str, required=True, help="Path to the readme")
    parser.add_argument("--gh-link", type=str, required=True, help="Link to the GitHub repo")
    args = parser.parse_args()

    notes_metadata = {}

    # Reads courses metadata
    for root, dirs, files in os.walk(args.src_path):
        if METADATA_FILENAME in files:
            with open(os.path.join(root, METADATA_FILENAME)) as f:
                metadata = json.load(f)
                dir_name = pathlib.PurePath(root).name
                gh_path = os.path.join(args.gh_link, dir_name)
                
                if metadata["year"] not in notes_metadata: notes_metadata[metadata["year"]] = {}
                if metadata["semester"] not in notes_metadata[metadata["year"]]: notes_metadata[metadata["year"]][metadata["semester"]] = {}

                notes_metadata[metadata["year"]][metadata["semester"]][metadata["name"]] = {
                    "name": metadata["name"],
                    "content": [
                        {
                            "name": pdf["name"],
                            "url": os.path.join(gh_path, pdf["path"])
                        }
                        for pdf in metadata["pdfs"]
                    ]
                }

    # Appends links to README
    with open(args.readme_path, "a") as readme_f:
        readme_f.write(f"\n\n## Table of contents\n")
        for year in sorted(notes_metadata.keys()):
            readme_f.write(f"\n### Year {year}\n")

            for semester in sorted(notes_metadata[year].keys()):
                for course in sorted(notes_metadata[year][semester]):
                    course_name = notes_metadata[year][semester][course]["name"]
                    course_content = notes_metadata[year][semester][course]["content"]

                    if (len(course_content) == 1) and (course_content[0]["name"] is None):
                        readme_f.write(f"- [{course_name}]({course_content[0]['url']})\n")
                    else:
                        readme_f.write(f"- {course_name}\n")
                        for content in course_content:
                            readme_f.write(f"   - [{content['name']}]({content['url']})\n")
