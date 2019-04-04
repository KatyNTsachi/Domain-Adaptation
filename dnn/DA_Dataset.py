import scipy.io as sio
import numpy as np
import torch
import torchvision
import torchvision.transforms as transforms
from torch.utils.data import Dataset, DataLoader

class DA_Dataset(Dataset):
    """Face Landmarks dataset."""

    def __init__(self, root_dir):
        """
        Args:
            csv_file (string): Path to the csv file with annotations.
            root_dir (string): Directory with all the images.
            transform (callable, optional): Optional transform to be applied
                on a sample.
        """
        self.root_dir = root_dir
       
        file_path   = self.root_dir + 'labels' + '.mat'
        y = sio.loadmat(file_path)
        self.lables = y['lable']

    def __len__(self):
        return len(self.lables)

    def __getitem__(self, idx):
        
        file_path = self.root_dir + str(idx+1) + '.mat'
        x         = sio.loadmat(file_path)
        x         = np.transpose( x['x'] )

        lable = self.lables[idx][0]-1
      
    
        sample = {'x': x, 'lable': lable}
      

        return sample