import os

# Get user inputs
confirm = input("Are you sure you want to create a new repository? (y/n): ").lower() == 'y'
readme = input("Do you want to create a README file? (y/n): ").lower() == 'y'
repo_url = input("Enter the repository URL (e.g., https://github.com/user/repo.git): ").strip()
repo_name = input("Enter the repository name: ").strip()
include_files = input("Do you want to include all files (git add .)? (y/n): ").lower() == 'y'
path = input("Enter the path where you want to create the repository (default is current directory): ").strip()

def validate_inputs():
    # Check repo_url format (basic check for Git URL)
    if not repo_url.endswith('.git') or not ('http://' in repo_url or 'https://' in repo_url or 'git@' in repo_url):
        print("Error: Invalid repository URL. Must be a valid Git URL (e.g., https://github.com/user/repo.git).")
        return False
    # Check repo_name for invalid characters
    if any(c in repo_name for c in '/\\:*?"<>|'):
        print("Error: Repository name contains invalid characters.")
        return False
    # Check path (if provided)
    if path and not os.path.isdir(path):
        print(f"Error: Path '{path}' does not exist or is not a directory.")
        return False
    return True

def create_repo():
    # Use current dir if path is empty
    target_dir = path if path else os.getcwd()
    # Ensure path exists
    if path and not os.path.exists(target_dir):
        os.makedirs(target_dir)
    # Check if already a Git repo
    if os.path.exists(os.path.join(target_dir, '.git')):
        print(f"Error: A Git repository already exists in {target_dir}.")
        return False
    # Run Git commands in the target directory
    cmd_prefix = f"cd {shlex_quote(target_dir)} && "
    if os.system(f"{cmd_prefix}git init") != 0:
        print("Error: Failed to initialize Git repository.")
        return False
    if os.system(f"{cmd_prefix}git branch -M main") != 0:
        print("Error: Failed to rename branch to main.")
        return False
    if os.system(f"{cmd_prefix}git remote add origin {shlex_quote(repo_url)}") != 0:
        print("Error: Failed to add remote origin.")
        return False
    return True

def create_readme():
    target_dir = path if path else os.getcwd()
    cmd_prefix = f"cd {shlex_quote(target_dir)} && "
    if os.system(f"{cmd_prefix}touch README.md") != 0:
        print("Error: Failed to create README.md.")
        return False
    if os.system(f"{cmd_prefix}echo '# {shlex_quote(repo_name)}' >> README.md") != 0:
        print("Error: Failed to write to README.md.")
        return False
    if os.system(f"{cmd_prefix}git add README.md") != 0:
        print("Error: Failed to stage README.md.")
        return False
    return True

def add_files():
    target_dir = path if path else os.getcwd()
    cmd_prefix = f"cd {shlex_quote(target_dir)} && "
    if os.system(f"{cmd_prefix}git add .") != 0:
        print("Error: Failed to stage all files.")
        return False
    return True

def push_repo():
    target_dir = path if path else os.getcwd()
    cmd_prefix = f"cd {shlex_quote(target_dir)} && "
    if os.system(f"{cmd_prefix}git commit -m 'Initial commit'") != 0:
        print("Error: Failed to commit changes.")
        return False
    if os.system(f"{cmd_prefix}git push -u origin main") != 0:
        print("Error: Failed to push to remote repository.")
        return False
    return True

def shlex_quote(s):
    import shlex
    return shlex.quote(s)

if confirm:
    if validate_inputs():
        if create_repo():
            if readme and not create_readme():
                exit(1)
            if include_files and not add_files():
                exit(1)
            if (readme or include_files) and not push_repo():
                exit(1)
            print(f"Repository created successfully in {path if path else os.getcwd()}.")
else:
    print("Operation cancelled.")
