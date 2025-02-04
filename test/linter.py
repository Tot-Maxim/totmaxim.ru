import subprocess
import os

def run_pylint(file_path):
    result = subprocess.run(['pylint', file_path], capture_output=True, text=True)
    print(result.stdout)
    if result.returncode != 0:
        print("Linting issues found:")
        print(result.stderr)

def run_eslint(directory_path):
    eslint_path = os.path.join('..', 'node_site', 'node_modules', '.bin', 'eslint')
    config_path = os.path.join('..', 'node_site', 'eslint.config.cjs')
    
    os.chdir(os.path.join('..', 'node_site'))

    js_files = []
    for root, dirs, files in os.walk('.'):
        if 'node_modules' in dirs:
            dirs.remove('node_modules')
        for file in files:
            if file.endswith('.js'):
                js_files.append(os.path.join(root, file))

    result = subprocess.run([eslint_path, '-c', config_path] + js_files, capture_output=True, text=True)

    print(result.stdout)
    if result.returncode!= 0:
        print("Linting issues found:")
        print(result.stderr)


def run_htmlhint(file_path):
    result = subprocess.run(['htmlhint', file_path], capture_output=True, text=True)
    print(result.stdout)
    if result.returncode != 0:
        print("Linting issues found:")
        print(result.stderr)



def run_checkstyle(file_path):
    result = subprocess.run(['java', '-jar', 'checkstyle.jar', '-c', 'checkstyle.xml', file_path], capture_output=True, text=True)
    print(result.stdout)
    if result.returncode != 0:
        print("Linting issues found:")
        print(result.stderr)


# run_htmlhint('your_html_file.html')

# run_checkstyle('YourJavaFile.java')

# run_pylint('your_python_file.py')

run_eslint('../node_site')