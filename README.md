# My BASH Script Collection

This repository contains some BASH scripts that I have made over the years. I have found them useful in my day to day operations and feel they are at a point where I can share them with the world. They may not be perfect, and they may not follow the BASH scripting directives, but they work for what I need them to do. They may be useful to you too.

### flac2mp3.sh - FLAC to MP3 Converter
This is a simple script that takes input FLAC file(s) in a directory and creates output MP3 file(s). Commonly used to convert high quality lossless FLAC audio to high quality lossy MP3 audio for portable music players and devices that do not support the FLAC file format.

### ifc.sh - Individual File Compressor
This simple script compresses individual files with the same extension. It is useful for compressing emulator ROMs or PDFs.
I was inspired to write this script based on a utility I used for Windows(tm) quite some time ago called ZipOne. It was/is a command line utility that was designed to do the same thing this script does.

### webaom.sh - AniDB WebAOM Java WebStart Downloader
This is a simple script that downloads webaom.jnlp from static.anidb.net and runs the client locally. Since the script always downloads the webaom.jnlp file each time it is run, it will make sure you are running the latest version of the java client (even though it hasn't been updated in ages).
Information about the AniDB WebAOM (Anime-O-Matic) can be found at: http://wiki.anidb.info/w/WebAOM

### ytdlsf.sh - YouTube (and others) File Downloader
This is a simple script that uses 'youtube-dl' to download almost any video from YouTube or other sites supported by the 'youtube-dl' utility. It will not allow you to download videos that are private or cost money, like video rentals. This script was designed to allow you to backup or recover your local lost videos. Do not abuse the system. They're watching.

# How can you help?

I know my scripting practices do not follow any sort of guidelines. For the most part, these scripts are just slapped together and use lots of duct tape to keep them from falling apart.

If you have suggestions on better ways of making a task work or easier ways of structuring the code, please file a bug against the script in question with your suggestion. Thank you.
