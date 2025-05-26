import re
from datetime import datetime

with open('VERSION', 'r') as f:
    new_version = f.read().strip()

current_year = datetime.now().year

# --- Update fpm.toml ---
with open('fpm.toml', 'r') as f:
    content = f.read()

# Update version fields
content = re.sub(
    r'(version\s*=\s*)"[0-9]+\.[0-9]+\.[0-9]+"',
    rf'\1"{new_version}"',
    content
)
content = re.sub(
    r'(\[extra\.ford\].*?version\s*=\s*)"[0-9]+\.[0-9]+(\.[0-9]+)?"',
    rf'\1"{new_version}"',
    content,
    flags=re.DOTALL
)

# Update year ranges only
content = re.sub(
    r'(\d{4})-(\d{1,4})',
    lambda m: f'{m.group(1)}-{current_year}' if len(m.group(2)) != 4 or int(m.group(2)) != current_year else m.group(0),
    content
)

with open('fpm.toml', 'w') as f:
    f.write(content)

# --- Update CMakeLists.txt ---
with open('CMakeLists.txt', 'r') as f:
    cmake_content = f.read()

cmake_content = re.sub(
    r'(set\(PROJECT_VERSION\s+")\d+\.\d+\.\d+("\))',
    rf'\g<1>{new_version}\2',
    cmake_content
)

with open('CMakeLists.txt', 'w') as f:
    f.write(cmake_content)
