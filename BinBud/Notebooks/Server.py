from flask import Flask, request
import os




import warnings
warnings.filterwarnings('ignore')


import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import plotly.graph_objects as go
from PIL import Image
import cv2


import tensorflow as tf
from keras import layers
from keras.layers import Input, Lambda, Dense, Flatten, Dropout, BatchNormalization
from keras.models import Model, loadmodel
from keras.optimizers import Adam
from keras.callbacks import ModelCheckpoint, EarlyStopping, ReduceLROnPlateau

from keras.applications.vgg19 import VGG19
from keras.applications.vgg16 import VGG16

from keras.preprocessing import image
from tensorflow.keras.preprocessing.image import ImageDataGenerator

from keras.models import Sequential
from sklearn.modelselection import traintestsplit
from sklearn.metrics import confusionmatrix, classificationreport

from BinBudMethods import BinBud

vgg16 = load_model("C:/Users/14158/BrodyCode/HackDavis/FINAL_VGG16.keras")
model = BinBud(model=vgg16)



app = Flask(__name)

@app.route('/hi')
def printsomething():
    return 'test'

@app.route('/upload', methods=['POST'])
def upload_image():
    print('\n\nRECEIVED NOTI\n\n')
    if 'file' not in request.files:
        return 'No file part', 400

    file = request.files['file']
    if file.filename == '':
        return 'No selected file', 400

    if file:
        filename = file.filename
        folderpath = 'C:/Users/14158/OneDrive/Desktop/ServerImages'
        # Corrected the filepath by removing the extra quotes
        filepath = os.path.join(folderpath, filename)

        file.save(filepath)

        modelOutput = model.predict_folder(folderpath)

        output_dict = {
            "label_1": modelOutput[0],
            "confidence": modelOutput[1],
            "label_2": modelOutput[2]
        }

        print(output_dict)






        return 'File successfully uploaded', 200

if __name == '__main':
    app.run(debug=True, host='0.0.0.0', port=5002)
