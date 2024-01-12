Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue | # Fortæller hvilke filer der ligger i gældende "Path"
    Sort-Object Length -Descending | # Sortere efter at største fil ligger øverst i listen
    Select-Object -First 10 | # Viser kun de 10 første resultater
    Format-Table # Formatere outputtet til et table