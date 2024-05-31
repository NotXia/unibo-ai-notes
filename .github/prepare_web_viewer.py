import argparse
from read_metadata import readMetadata
import re
import os
# from pathlib import Path
# import shutil


if __name__ == "__main__":
    parser = argparse.ArgumentParser(prog="Web viewer formatter")
    parser.add_argument("--src-path", type=str, required=True, help="Path to the .tex sources (for metadata)")
    parser.add_argument("--out-path", type=str, required=True, help="Path of the output directory")
    parser.add_argument("--gh-raw-pdf-url", type=str, required=True, help="Base URL of Github raw pdfs")
    # parser.add_argument("--pdfs-path", type=str, required=True, help="Path of the pdfs directory")
    parser.add_argument("--template-path", type=str, default="./web-viewer", help="Path to the templates")
    args = parser.parse_args()

    notes_metadata = readMetadata(args.src_path)
    table_of_content = ""
    url_pdf_dir = "pdfs"
    dest_pdf_dir = os.path.join(args.out_path, url_pdf_dir)
    with open(os.path.join(args.template_path, "index.html"), "r") as f: index_template = f.read()
    # with open(os.path.join(args.template_path, "view.html"), "r") as f: viewer_template = f.read()

    os.makedirs(args.out_path, exist_ok=True)
    # shutil.copytree(args.pdfs_path, dest_pdf_dir, dirs_exist_ok=True)


    # Generate home page content
    for year in sorted(notes_metadata.keys()):
        for semester in sorted(notes_metadata[year].keys()):
            for course in sorted(notes_metadata[year][semester]):
                course_name = notes_metadata[year][semester][course]["name"]
                course_content = notes_metadata[year][semester][course]["content"]

                if (len(course_content) == 1) and (course_content[0]["name"] is None):
                    table_of_content += f"<h3><a href='{os.path.join(args.gh_raw_pdf_url, course_content[0]['url'])}'>{course_name}</a></h3>\n"
                else:
                    table_of_content += f"<h3>{course_name}</h3>\n"
                    table_of_content += "<ul>\n"
                    for content in course_content:
                        table_of_content += f"<li><h4><a href='{os.path.join(args.gh_raw_pdf_url, content['url'])}'>{content['name']}</a></h4></li>\n"
                    table_of_content += "</ul>\n"

    with open(os.path.join(args.out_path, "index.html"), "w") as f:
        f.write(
            re.sub(
                r"<!-- begin-toc -->[\s\S]*<!-- end-toc -->", 
                f"<!-- begin-toc -->\n{table_of_content}\n<!-- end-toc -->", 
                index_template
            )
        )


    # Generate viewer content
    # for year in notes_metadata.keys():
    #     for semester in notes_metadata[year].keys():
    #         for course in notes_metadata[year][semester]:
    #             course_name = notes_metadata[year][semester][course]["name"]
    #             course_content = notes_metadata[year][semester][course]["content"]

    #             for content in course_content:
    #                 content_local_path = os.path.join(url_pdf_dir, content["url"])
    #                 content_html_name = f"{Path(content['url']).stem}.html"
    #                 with open(os.path.join(args.out_path, content_html_name), "w") as f:
    #                     page_content = re.sub(r"{{pdf-path}}", f"{content_local_path}", viewer_template)
    #                     page_content = re.sub(r"{{course-name}}", f"{Path(content['url']).name}", page_content)
    #                     f.write(page_content)