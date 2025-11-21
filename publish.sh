#!/bin/bash

# Script to publish site to GitHub Pages

echo "📦 Publishing La Trévannière website to GitHub Pages..."

# Check if we're in the right directory
if [ ! -f "index.html" ]; then
    echo "❌ Error: index.html not found. Run this script from the repository root."
    exit 1
fi

# Check if there are uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "⚠️  You have uncommitted changes. Please commit them first."
    git status --short
    exit 1
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)

echo "📋 Current branch: $CURRENT_BRANCH"

# Stash any untracked files
git stash push -u -m "Temporary stash before gh-pages deployment"

# Create or switch to gh-pages branch
echo "🔀 Switching to gh-pages branch..."
if git show-ref --verify --quiet refs/heads/gh-pages; then
    git checkout gh-pages
    git merge main -m "Update from main branch"
else
    git checkout -b gh-pages
fi

# Push to gh-pages
echo "🚀 Pushing to gh-pages..."
git push -u origin gh-pages

# Switch back to original branch
echo "🔙 Returning to $CURRENT_BRANCH branch..."
git checkout $CURRENT_BRANCH

# Restore stashed files if any
if git stash list | grep -q "Temporary stash before gh-pages deployment"; then
    git stash pop
fi

echo "✅ Successfully published to GitHub Pages!"
echo "🌐 Your site will be available at: https://chalky66.github.io/la-trevanniere"
echo "⏱️  It may take a few minutes for changes to appear."
