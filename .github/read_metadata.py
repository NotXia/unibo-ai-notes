import os
import json


def readMetadata(src_path, gh_link="", metadata_file_name="metadata.json"):
    notes_metadata = {}

    # Reads courses metadata
    for root, _, files in os.walk(src_path):
        if metadata_file_name in files:
            with open(os.path.join(root, metadata_file_name)) as f:
                metadata = json.load(f)
                dir_name = os.path.relpath(root, src_path)
                gh_path = os.path.join(gh_link, dir_name)
                
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

    return notes_metadata