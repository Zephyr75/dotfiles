git pull
git add .
git diff --quiet && git diff --staged --quiet || git commit -am "`date`"
git push
