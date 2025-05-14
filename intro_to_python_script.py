import ensurepip
import sys
import subprocess
import urllib.request
ensurepip.bootstrap()
def install_package(package_name):
    python_executable = sys.executable
    try:
        subprocess.check_call([python_executable, "-m", "pip", "install", package_name])
    except subprocess.CalledProcessError:
        print(f"Failed to install '{package_name}' using {python_executable}")
if __name__ == "__main__":
    install_package("biopython")
import Bio
from Bio import SeqIO