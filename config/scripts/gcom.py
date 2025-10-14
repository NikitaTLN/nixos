import subprocess

def run_cmd(cmd):
    subprocess.run(cmd, shell=True, check=True)

commit_message = input("Enter your commit message: ").strip()
files_add = input("Enter files to add (separated by spaces, or leave empty for all): ").strip()

if not files_add:
    files_add = "."

run_cmd(f"git add {files_add}")

run_cmd(f'git commit -m "feat: {commit_message}"')

run_cmd("git push origin HEAD")

print("✅ Changes have been committed and pushed.")
