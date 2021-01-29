import  threading, os, time
import queue
import shutil
from glob import glob

fileQueue = queue.Queue()
j =2
destPath = f'1000{j}'

class ThreadedCopy:
    totalFiles = 0
    copyCount = 0
    lock = threading.Lock()

    def __init__(self):
        
        fileList =  glob(f'drive/MyDrive/100k_models/1000{j}/*')

        if not os.path.exists(destPath):
            os.mkdir(destPath)

        self.totalFiles = len(fileList)

        print(str(self.totalFiles) + " files to copy.")
        self.threadWorkerCopy(fileList)


    def CopyWorker(self):
        while True:
            fileName = fileQueue.get()
            shutil.copy(fileName, destPath)
            fileQueue.task_done()
            with self.lock:
                self.copyCount += 1
                percent = (self.copyCount * 100) / self.totalFiles
                print(str(percent) + " percent copied.")

    def threadWorkerCopy(self, fileNameList):
        for i in range(32):
            t = threading.Thread(target=self.CopyWorker)
            t.daemon = True
            t.start()
        for fileName in fileNameList:
            fileQueue.put(fileName)
        fileQueue.join()

ThreadedCopy()
