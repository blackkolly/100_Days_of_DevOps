The Nautilus application development team was working on a git repository /opt/ecommerce.git which is cloned under /usr/src/kodekloudrepos 
directory present on Storage server in Stratos DC. The team want to setup a hook on this repository, please find below more details:

Merge the feature branch into the master branch`, but before pushing your changes complete below point.

Create a post-update hook in this git repository so that whenever any changes are pushed to the master branch, 
it creates a release tag with name release-2023-06-15, where 2023-06-15 is supposed to be the current date. 
For example if today is 20th June, 2023 then the release tag must be release-2023-06-20. Make sure you test the hook at 
least once and create a release tag for today's release.

Finally remember to push your changes.
Note: Perform this task using the natasha user, and ensure the repository or existing directory permissions are not altered.


# Git Post-Update Hook - Quick Execution Guide

## Server Information
- **Server**: ststor01 (172.16.238.15)
- **User**: natasha
- **Password**: Bl@kW
- **Repository Path**: /usr/src/kodekloudrepos/ecommerce
- **Bare Repo**: /opt/ecommerce.git

---

## Step-by-Step Execution

### 1. Connect to Storage Server
```bash
ssh natasha@172.16.238.15
# Enter password: Bl@kW
```

### 2. Navigate to Repository and Check Status
```bash
cd /usr/src/kodekloudrepos/ecommerce
git status
git branch -a
```

### 3. Merge Feature Branch into Master
```bash
# Switch to master branch
git checkout master

# List all branches to confirm feature branch name
git branch -a

# Merge feature branch (adjust name if different)
git merge feature

# If conflicts occur, resolve them and commit
```

### 4. Fix the Post-Update Hook (CORRECTED)
```bash
# Navigate to hooks directory of bare repository
cd /opt/ecommerce.git/hooks

# Create the CORRECTED post-update hook
cat > post-update << 'EOF'
#!/bin/bash
# Post-update hook for automatic release tagging

CURRENT_DATE=$(date +%Y-%m-%d)
RELEASE_TAG="release-${CURRENT_DATE}"
WORK_TREE="/usr/src/kodekloudrepos/ecommerce"
GIT_DIR="/opt/ecommerce.git"

for ref in "$@"; do
    if [ "$ref" = "refs/heads/master" ]; then
        echo "Master branch updated, creating release tag: ${RELEASE_TAG}"
        
        # Unset GIT_DIR to work in the working tree
        unset GIT_DIR
        
        # Navigate to work tree
        cd "${WORK_TREE}" || exit 1
        
        # Create the tag
        git tag -a "${RELEASE_TAG}" -m "Release tag for ${CURRENT_DATE}"
        
        # Push the tag to origin
        git push origin "${RELEASE_TAG}" 2>&1
        
        echo "Release tag ${RELEASE_TAG} created and pushed"
    fi
done
exit 0
EOF

# Make the hook executable
chmod +x post-update

# Verify hook creation
ls -la post-update
cat post-update
```

### 5. Test the Hook
```bash
# Go back to working repository
cd /usr/src/kodekloudrepos/ecommerce

# Create a test change
echo "# Hook test" >> README.md

# Commit the change
git add README.md
git commit -m "Testing post-update hook"
```

### 6. Push Changes and Trigger Hook
```bash
# Push to master (this triggers the hook)
git push origin master

# Verify tag was created
git tag -l "release-*"

# Check if tag was pushed to remote
git ls-remote --tags origin
```

### 7. Final Verification
```bash
# List all tags
git tag

# Show tag details
git show release-$(date +%Y-%m-%d)

# View commit log with tags
git log --oneline --decorate -5
