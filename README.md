# Windows Downloads Organizer

A small Windows batch script that sorts files in the folder containing the script into folders based on file extensions.

## Categories

- **Videos:** MP4, MKV, AVI, MOV, WMV, FLV, WEBM, 3GP
- **Photos:** JPG, JPEG, PNG, GIF, BMP, WEBP, HEIC, SVG
- **Documents:** PDF, DOC, DOCX, XLS, XLSX, CSV, PPT, PPTX
- **Text files:** TXT
- **Music:** MP3, WAV, AAC, FLAC, M4A, OGG
- **Archives:** ZIP, RAR, 7Z, TAR, GZ
- **Apps/installers:** EXE, MSI, APK
- **Others:** Unclassified files

## How to use

1. Download `Start_fixed.bat` from this repository.
2. Make a backup of important files and test the script in a temporary folder first.
3. Copy `Start_fixed.bat` into the folder you want to organize (for example, your Downloads folder).
4. Double-click the script and review the preview in the Command Prompt window.
5. Enter `Y` to proceed or `N` to cancel.
6. Review any `[SKIPPED]` or `[ERROR]` messages after it finishes.

## Safety and limitations

- The script works only on files directly inside the folder where it is placed; it does not scan subfolders.
- It moves files rather than copying them.
- It leaves folders, this script, other `.bat` / `.cmd` / `.ps1` scripts, and common incomplete-download files in place.
- If a file with the same name already exists in the destination category folder, that file is skipped rather than intentionally overwritten.
- Always read the batch file's source code and test it with sample files before using it on important folders. Review the preview before confirming.

## License

No license has been added by default. If you want other people to freely use, modify, and redistribute this project, choose and add an open-source license that matches your intentions.
