# pip install PyGithub python-dotenv

import yaml
from github import Github
from github.GithubException import UnknownObjectException
from dotenv import load_dotenv
import os
from tkinter import Tk, filedialog, messagebox

# Load environment variables from .env file
load_dotenv()

# Retrieve GitHub credentials from environment variables
GITHUB_TOKEN = os.getenv('GITHUB_TOKEN')
REPO_OWNER = os.getenv('REPO_OWNER')
NEW_REPO_NAME = os.getenv('REPO_NAME')
REPO_DESCRIPTION = os.getenv('REPO_DESCRIPTION')
REPO_PRIVATE = os.getenv('REPO_PRIVATE', 'False').lower() == 'true'

# Authenticate to GitHub
g = Github(GITHUB_TOKEN)

# Create a Tkinter root window (it won't be shown)
root = Tk()
root.withdraw()

# Function to check if repository exists
def repo_exists(owner, repo_name):
    try:
        g.get_repo(f"{owner}/{repo_name}")
        return True
    except UnknownObjectException:
        return False

# Check if the repository already exists
if repo_exists(REPO_OWNER, NEW_REPO_NAME):
    confirm = messagebox.askyesno(
        title="Repository Already Exists",
        message=f"The repository '{NEW_REPO_NAME}' already exists. Do you want to continue with this repository?"
    )
    if not confirm:
        print("User chose not to continue with the existing repository. Exiting.")
        exit(1)
    else:
        repo = g.get_repo(f"{REPO_OWNER}/{NEW_REPO_NAME}")
else:
    # Create a new repository
    user = g.get_user()
    new_repo = user.create_repo(
        name=NEW_REPO_NAME,
        description=REPO_DESCRIPTION,
        private=REPO_PRIVATE
    )
    repo = new_repo
    print(f"Repository '{NEW_REPO_NAME}' created successfully.")

# Open a file dialog to select the YAML file
file_path = filedialog.askopenfilename(
    title="Select the YAML file",
    filetypes=(("YAML files", "*.yaml"), ("All files", "*.*"))
)

# Check if a file was selected
if not file_path:
    print("No file selected.")
    exit(1)

print("Generating data from selected file: ", file_path)
# Read data from the selected YAML file
with open(file_path, 'r', encoding='utf-8') as file:
    project_data = yaml.safe_load(file)
print("Data read successfully.")

# Create milestones and store their numbers
milestone_dict = {}
for milestone in project_data['milestones']:
    created_milestone = repo.create_milestone(title=milestone['title'], description=milestone['description'])
    milestone_dict[milestone['title']] = created_milestone.number

print("Finished creating milestones.")
print("Creating issues...")

# Create issues and assign them to their respective milestones
for i, issue in enumerate(project_data['issues']):
    if i % 5 == 0:
        print(f"Creating issue {i + 1}/{len(project_data['issues'])}...")
    repo.create_issue(
        title=issue['title'],
        body=issue['body'],
        milestone=repo.get_milestone(milestone_dict[issue['milestone']])
    )

print("Milestones and issues created successfully.")