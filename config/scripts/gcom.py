import subprocess
import shlex

def run_cmd(cmd):
    try:
        # Split command into list to avoid shell injection
        cmd_list = shlex.split(cmd)
        result = subprocess.run(
            cmd_list,
            check=True,
            text=True,  # Ensure output is returned as string
            capture_output=True  # Capture stdout and stderr
        )
        return result
    except subprocess.CalledProcessError as e:
        print(f"❌ Command failed: {e.cmd}")
        print(f"Error output: {e.stderr}")
        raise
    except Exception as e:
        print(f"❌ Unexpected error: {str(e)}")
        raise

def validate_input(user_input):
    """Ensure input doesn't contain dangerous characters."""
    dangerous_chars = [';', '&', '|', '`']
    for char in dangerous_chars:
        if char in user_input:
            raise ValueError(f"Input contains invalid character: {char}")
    return user_input

# Get user input
commit_message = input("Enter your commit message: ").strip()
files_add = input("Enter files to add (separated by spaces, or leave empty for all): ").strip()

# Validate inputs
try:
    commit_message = validate_input(commit_message)
    if files_add:
        files_add = validate_input(files_add)
    else:
        files_add = "."
except ValueError as e:
    print(f"❌ Invalid input: {e}")
    exit(1)

# Run git commands
try:
    run_cmd(f"git add {files_add}")
    run_cmd(f'git commit -m "{commit_message}"')
    run_cmd("git push origin HEAD")
    print("✅ Changes have been committed and pushed.")
except subprocess.CalledProcessError:
    print("❌ Git operation failed. Check the error output above.")
except Exception as e:
    print(f"❌ An unexpected error occurred: {str(e)}")
