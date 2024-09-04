import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
# import plotly.graph_objects as go
from PIL import Image
import cv2


import tensorflow as tf
from keras import layers
from keras.layers import Input, Lambda, Dense, Flatten, Dropout, BatchNormalization
from keras.models import Model, load_model
from keras.optimizers import Adam
from keras.callbacks import ModelCheckpoint, EarlyStopping, ReduceLROnPlateau

from keras.applications.vgg19 import VGG19
from keras.applications.vgg16 import VGG16

from keras.preprocessing import image
from tensorflow.keras.preprocessing.image import ImageDataGenerator

from keras.models import Sequential
from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix, classification_report
import os


# Update the preprocess_input import
from keras.applications.vgg16 import preprocess_input


class BinBud:
    def __init__(self, model) -> None:
        self.vgg16 = model
        self.outputs = ["battery", "biological", "cardboard", "cement",
        "clothes", "electronics", "glass", "leather", "metal","paper", "plastic", "rubber", "trash", "wood"]

    def load_and_preprocess_image(self, img_path):
        img = image.load_img(img_path, target_size=(224, 224))
        img_array = image.img_to_array(img)
        img_array_expanded = np.expand_dims(img_array, axis=0)
        return preprocess_input(img_array_expanded)

    def plot_images(self, original, preprocessed):
        fig, axs = plt.subplots(1, 2, figsize=(10, 5))
        axs[0].imshow(original)
        axs[0].set_title('Original Image')
        axs[0].axis('off')

        # Convert preprocessed image back to a displayable format
        preprocessed_display = np.clip(preprocessed[0] * 0.5 + 0.5, 0, 1)
        axs[1].imshow(preprocessed_display)
        axs[1].set_title('Preprocessed Image')
        axs[1].axis('off')
        plt.show()

    def predict_folder(self, folder_path):
        solutionString = ""

        for img_file in os.listdir(folder_path):
            img_path = os.path.join(folder_path, img_file)
            if img_path.lower().endswith(('.png', '.jpg', '.jpeg')):
                original_image = Image.open(img_path)
                preprocessed_image = self.load_and_preprocess_image(img_path)

                # If you want to see the preprocessing taking place
                # self.plot_images(original_image, preprocessed_image)

                predicted_array = self.vgg16.predict(preprocessed_image)
                
                predicted_value = self.outputs[np.argmax(predicted_array)]
                
                predicted_accuracy = round(np.max(predicted_array) * 100, 2)
                print("pred acc ROUND: ", round(np.max(predicted_array) * 100, 2))
                print(f"{img_file}: Your waste material is {predicted_value} with {predicted_accuracy}% accuracy.")
                
                
        if round(np.max(predicted_array) * 100, 2) > 50:
            if predicted_value in ["battery", "electronics"]:
                solutionString = f"Your waste material is {predicted_value}. Therefore, you should dispose of it at an e-waste facility."
            elif predicted_value == "biological":
                solutionString = f"Your waste material is {predicted_value}. Therefore, you should compost it."
            elif predicted_value == "cardboard":
                solutionString = f"Your waste material is {predicted_value}. Therefore, you should recycle it."
            elif predicted_value == "cement":
                solutionString = f"Your waste material is {predicted_value}. Therefore, it should be disposed of in construction waste."
            elif predicted_value == "clothes":
                solutionString = f"Your waste material is {predicted_value}. Therefore, you should donate it or dispose of it in a textile bin."
            elif predicted_value == "glass":
                solutionString = f"Your waste material is {predicted_value}. Therefore, you should recycle it."
            elif predicted_value == "leather":
                solutionString = f"Your waste material is {predicted_value}. Consider donating it or using a special waste disposal service."
            elif predicted_value == "metal":
                solutionString = f"Your waste material is {predicted_value}. Therefore, you should recycle it."
            elif predicted_value == "paper":
                solutionString = f"Your waste material is {predicted_value}. Therefore, you should recycle it."
            elif predicted_value == "plastic":
                solutionString = f"Your waste material is {predicted_value}. Therefore, you should recycle it if it's recyclable or dispose of it properly."
            elif predicted_value == "rubber":
                solutionString = f"Your waste material is {predicted_value}. Consider taking it to a special recycling or disposal facility."
            elif predicted_value == "trash":
                solutionString = f"Your waste material is {predicted_value}. Unfortunately, this should go to the landfill."
            elif predicted_value == "wood":
                solutionString = f"Your waste material is {predicted_value}. It can often be recycled or repurposed, depending on the condition."
        else:
            solutionString = "Our percentage of Accuracy is not high enough. We recommend that you try retaking the picture."
        return [predicted_value, predicted_accuracy, solutionString]
