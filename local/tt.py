import zipfile
with zipfile.ZipFile('samle.zip','w')as zf:
    zf.write('tt.py')
    
