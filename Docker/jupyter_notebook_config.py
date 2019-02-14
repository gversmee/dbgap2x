c = get_config()
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.port = 8888

c.FileContentsManager.delete_to_trash = False

c.IPKernelApp.pylab = 'inline'
c.NotebookApp.password = 'sha1:48b3bade9809:6e4fca934155cb2552e409a895a22534ff61a837'
