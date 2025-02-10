#!/usr/bin/env python

import os
import re

# Supported image extensions
IMAGE_EXTENSIONS = {'.png', '.jpg', '.jpeg', '.gif', '.bmp', '.tiff', '.webp'}

def update_readme_with_previews(root_path, all_directories):
    readme_path = os.path.join(root_path, "README.md")
    preview_section_start = "<!-- PREVIEW LINKS START -->"
    preview_section_end = "<!-- PREVIEW LINKS END -->"

    # Generate the preview links
    preview_links = "\n".join(
        f"- [{os.path.relpath(directory, root_path)}]({os.path.relpath(directory, root_path)}/PREVIEW.md)"
        for directory in all_directories
    )

    preview_content = f"{preview_section_start}\n{preview_links}\n{preview_section_end}"

    if os.path.exists(readme_path):
        with open(readme_path, "r") as readme_file:
            readme_content = readme_file.read()

        # Check if the preview section exists and update it
        if preview_section_start in readme_content and preview_section_end in readme_content:
            updated_content = re.sub(
                f"{re.escape(preview_section_start)}.*?{re.escape(preview_section_end)}", 
                preview_content, 
                readme_content, 
                flags=re.DOTALL
            )
        else:
            # Add the preview section at the end if it doesn't exist
            updated_content = readme_content.strip() + "\n\n" + preview_content

        with open(readme_path, "w") as readme_file:
            readme_file.write(updated_content)

        print(f"Updated README.md in: {root_path}")
    else:
        # Create a new README.md if it doesn't exist
        with open(readme_path, "w") as readme_file:
            readme_file.write(f"# Project Overview\n\n{preview_content}\n")

        print(f"Created README.md in: {root_path}")

def find_images_and_generate_markdown(root_path):
    all_directories = []

    for current_dir, _, files in os.walk(root_path):
        # Filter image files in the current directory
        image_files = [f for f in files if os.path.splitext(f)[1].lower() in IMAGE_EXTENSIONS]

        if image_files:
            # Path to the markdown file in the current directory
            preview_file_path = os.path.join(current_dir, "PREVIEW.md")
            all_directories.append(current_dir)

            with open(preview_file_path, "w") as preview_file:
                preview_file.write("# Image Previews\n\n")

                for image_file in image_files:
                    # Get relative path for markdown
                    relative_path = os.path.relpath(os.path.join(current_dir, image_file), root_path)
                    preview_file.write(f"![{image_file}]({relative_path})\n\n")

            print(f"Generated PREVIEW.md in: {current_dir}")

    # Update README.md in the root directory
    update_readme_with_previews(root_path, all_directories)

if __name__ == "__main__":
    # Prompt user for the directory path
    root_path = input("Enter the root directory path to search for images: ").strip()

    if os.path.isdir(root_path):
        find_images_and_generate_markdown(root_path)
    else:
        print("Invalid directory path. Please try again.")
