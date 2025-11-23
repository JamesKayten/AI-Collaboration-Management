"""
Setup script for AudioApp backend.
"""

from setuptools import setup, find_packages
from pathlib import Path

# Read the README file
readme_file = Path(__file__).parent / "README.md"
long_description = readme_file.read_text(encoding="utf-8") if readme_file.exists() else ""

setup(
    name="audioapp-backend",
    version="1.0.0",
    description="Python backend for AudioApp music player",
    long_description=long_description,
    long_description_content_type="text/markdown",
    author="AudioApp Contributors",
    author_email="",
    url="https://github.com/JamesKayten/AudioApp",
    license="MIT",
    packages=find_packages(exclude=["tests", "tests.*"]),
    python_requires=">=3.9",
    install_requires=[
        "fastapi>=0.109.0",
        "uvicorn[standard]>=0.27.0",
        "pydantic>=2.5.3",
        "pygame>=2.5.2",
        "pydub>=0.25.1",
        "mutagen>=1.47.0",
        "sqlalchemy>=2.0.25",
        "aiosqlite>=0.19.0",
        "python-multipart>=0.0.6",
        "aiofiles>=23.2.1",
        "watchdog>=4.0.0",
    ],
    extras_require={
        "dev": [
            "pytest>=7.4.4",
            "pytest-asyncio>=0.23.3",
            "black>=24.1.1",
            "flake8>=7.0.0",
        ],
    },
    entry_points={
        "console_scripts": [
            "audioapp-backend=backend.main:main",
        ],
    },
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: End Users/Desktop",
        "License :: OSI Approved :: MIT License",
        "Operating System :: MacOS :: MacOS X",
        "Operating System :: POSIX :: Linux",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Programming Language :: Python :: 3.12",
        "Topic :: Multimedia :: Sound/Audio :: Players",
    ],
    keywords="music player audio macos swiftui fastapi",
)
