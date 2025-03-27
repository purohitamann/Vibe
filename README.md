
# 📌 Best Practice: Always Use a Separate Branch for Each Issue

🚀 **To keep our codebase clean and organized**, follow this rule:  
**Each issue should be worked on in a separate branch, NOT directly on the `main` branch!**  

---

## ✅ Steps to Follow for Every Issue  

### 1️⃣ Switch to `main` & Pull the Latest Changes  
```bash
git checkout main
git pull origin main
```

### 2️⃣ Create a New Branch for the Issue  
```bash
git checkout -b issue-#<ISSUE_NUMBER>-<FEATURE_NAME>
```
🔹 **Example:** If working on **Login Screen (#1)**, use:  
```bash
git checkout -b issue-1-login-screen
```

### 3️⃣ Work on Your Changes 🚀  
- Implement the feature  
- Commit regularly  

### 4️⃣ Stage & Commit Your Changes  
```bash
git add .
git commit -m "Added login screen UI"
```

### 5️⃣ Push Your Branch to GitHub  
```bash
git push origin issue-1-login-screen
```

### 6️⃣ Create a Pull Request (PR) on GitHub  
- Go to your **GitHub repo**  
- Click **"Compare & pull request"**  
- Set **Base Branch = `main`**  
- Add a **clear description**  
- Request **review from teammates**  

### 7️⃣ Once Approved, Merge the PR  
```bash
git checkout main
git pull origin main
git branch -d issue-1-login-screen  # Delete local branch
git push origin --delete issue-1-login-screen  # Delete remote branch
```

---

## 🚀 Key Rules to Follow
✅ **Never push directly to `main`**  
✅ **Always create a new branch for each issue**  
✅ **Write meaningful commit messages**  
✅ **Always pull the latest `main` before creating a new branch**  
✅ **Delete your branch after merging to keep the repo clean**  

---

This ensures **clean, conflict-free collaboration**! 🚀🔥
