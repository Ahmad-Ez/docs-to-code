# Git Workflow SOP

A streamlined branching strategy where `main` is production, `dev` is integration, and releases flow through dedicated branches.

---

## Branch Overview

| Branch           | Purpose                    | Protected               |
| ---------------- | -------------------------- | ----------------------- |
| `main`           | Production code            | Yes - no direct commits |
| `dev`            | Feature integration        | Yes - requires PR       |
| `feature/*`      | Individual tasks           | No                      |
| `release/vX.X.X` | Release preparation        | No                      |
| `hotfix/*`       | Emergency production fixes | No                      |

---

## Merge Methods

**Use this as your quick reference:**

| Merging From → To    | Method               |
| -------------------- | -------------------- |
| `feature/*` → `dev`  | **Squash and Merge** |
| `release/*` → `main` | **Merge Commit**     |
| `release/*` → `dev`  | **Merge Commit**     |
| `hotfix/*` → `main`  | **Merge Commit**     |
| `hotfix/*` → `dev`   | **Merge Commit**     |

**Why?**

- **Squash** for features: One clean commit per PR. Easy to read, easy to revert.
- **Merge commit** for releases/hotfixes: Preserves history of what went to production.

---

## Feature Workflow

1. **Sync**: Update your local `dev` to match remote

   ```bash
   git checkout dev
   git pull origin dev
   ```

2. **Branch**: Create feature branch from `dev`

   ```bash
   git checkout --no-track -b feature/short-description origin/dev
   ```

   > Note: We use `--no-track` to ensure the local branch doesn't accidentally track `origin/dev`. We branch directly from `origin/dev` after fetching to ensure we have the latest.

3. **Commit**: Make atomic commits (one logical change each)

4. **Push & PR**: Push to GitHub, open PR against `dev`

   ```bash
   git push -u origin feature/short-description
   ```

   > Note: The `-u` flag sets the "upstream" tracking to the remote feature branch. This ensures VS Code's "Sync" button pushes to the feature branch, not `dev`.

5. **Review**: Get at least 1 approval

6. **Merge**: Use **Squash and Merge** on GitHub

7. **Cleanup**: Delete the feature branch

---

## Release Workflow

### Step 1: Create Release Branch

```bash
# Sync local dev with remote
git checkout dev
git pull origin dev

# Create release branch from dev
git checkout -b release/v1.1.0 dev
```

### Step 2: Polish (Optional)

- Bug fixes only
- Documentation updates
- Version bump
- **No new features**

### Step 3: Merge to Production

```bash
# Merge to main with merge commit
git checkout main
git pull origin main
git merge --no-ff release/v1.1.0
git push origin main

# Tag the release
git tag -a v1.1.0 -m "Release v1.1.0"
git push origin v1.1.0
```

### Step 4: Sync Back to Dev

```bash
git checkout dev
git merge --no-ff release/v1.1.0
git push origin dev
```

### Step 5: Cleanup

```bash
git branch -d release/v1.1.0
git push origin --delete release/v1.1.0
```

---

## Hotfix Workflow

For critical production bugs only.

### Step 1: Create Hotfix Branch

```bash
# Sync local main with remote
git checkout main
git pull origin main

# Create hotfix branch from main
git checkout -b hotfix/bug-description main
```

### Step 2: Fix & Test

### Step 3: Merge to Both Branches

```bash
# Merge to main
git checkout main
git merge --no-ff hotfix/bug-description
git tag -a v1.1.1 -m "Hotfix v1.1.1"
git push origin main --tags

# Merge to dev
git checkout dev
git merge --no-ff hotfix/bug-description
git push origin dev
```

### Step 4: Cleanup

```bash
git branch -d hotfix/bug-description
git push origin --delete hotfix/bug-description
```

---

## PR Requirements

- **Description**: What changed and why
- **Link Issues**: Reference related issue numbers
- **CI Pass**: All tests and linting must pass
- **Resolve Conflicts**: Author rebases on `dev` if needed

---

## GitHub Settings

### Branch Protection (Settings → Branches)

**For `main`:**

- [ ] Require PR before merging (1 approval)
- [ ] Require status checks to pass
- [ ] Require branches be up to date

**For `dev`:**

- [ ] Require PR before merging (1 approval)
- [ ] Require status checks to pass

### Merge Button Settings

- Enable: Squash merging, Merge commits
- Disable: Rebase merging
- Enable: Auto-delete head branches

---

## Roles

| Role             | Responsibility                                         |
| ---------------- | ------------------------------------------------------ |
| **Author**       | Write code, pass tests, resolve conflicts              |
| **Reviewer**     | Validate logic, check quality, approve/request changes |
| **Release Lead** | Create release branch, merge to `main`, tag release    |
