import argparse
from read_metadata import readMetadata


if __name__ == "__main__":
    parser = argparse.ArgumentParser(prog="README updater")
    parser.add_argument("--src-path", type=str, required=True, help="Path to the .tex sources")
    parser.add_argument("--readme-path", type=str, required=True, help="Path to the readme")
    parser.add_argument("--gh-link", type=str, required=True, help="Link to the GitHub repo")
    args = parser.parse_args()

    notes_metadata = readMetadata(args.src_path, args.gh_link)

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
                        readme_f.write(f"- [**{course_name}**]({course_content[0]['url']})\n")
                    else:
                        readme_f.write(f"- **{course_name}**\n")
                        for content in course_content:
                            readme_f.write(f"   - [{content['name']}]({content['url']})\n")
