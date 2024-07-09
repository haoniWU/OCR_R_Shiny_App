
""" Fonction basique
import pytesseract
pytesseract.pytesseract.tesseract_cmd = 'C:\\Program Files\\Tesseract-OCR\\tesseract.exe'
from PIL import Image, ImageFilter, ImageEnhance
#from tabulate import tabulate


# Reférence: https://www.youtube.com/watch?v=BK4mejo8uK0
def print_text(img_path):
	'''Affichage dans la console'''
	text = pytesseract.image_to_string(Image.open(img_path))
	return text
"""


""" Génère l'OCR sous forme de tableau mais pas très ouf
def preprocess_image(img_path):
    '''Prétraitement de l'image'''
    img = Image.open(img_path)
    # Améliorer le contraste
    enhancer = ImageEnhance.Contrast(img)
    img = enhancer.enhance(2)
    # Convertir en niveaux de gris
    img = img.convert('L')
    # Appliquer un filtre de netteté
    img = img.filter(ImageFilter.SHARPEN)
    return img

def print_text(img_path):
    '''OCR d'une image de tableau avec remplacement des cellules vides par "N/A"'''
    # Prétraiter l'image
    img = preprocess_image(img_path)
    # Effectuer l'OCR
    text = pytesseract.image_to_string(img)
    # Diviser le texte en lignes
    lines = text.split('\n')
    # Créer le tableau de données
    table_data = []
    max_columns = 0
    for line in lines:
        # Diviser chaque ligne en colonnes
        columns = line.split()
        # Remplacer les cellules vides par "N/A"
        columns = ["N/A" if not col.strip() else col.strip() for col in columns]
        table_data.append(columns)
        if len(columns) > max_columns:
            max_columns = len(columns)
    
    # Normaliser la longueur de chaque ligne pour qu'elles aient le même nombre de colonnes
    for row in table_data:
        while len(row) < max_columns:
            row.append("N/A")
    
    # Afficher le tableau
    print(tabulate(table_data))
"""

""" OCR avec prétraitement
def preprocess_image(img_path):
    '''Prétraitement de l'image'''
    img = Image.open(img_path)
    # Améliorer le contraste
    enhancer = ImageEnhance.Contrast(img)
    img = enhancer.enhance(2)
    # Convertir en niveaux de gris
    img = img.convert('L')
    # Appliquer un filtre de netteté
    img = img.filter(ImageFilter.SHARPEN)
    return img

def print_text(img_path):
    '''Affichage dans la console'''
    img = preprocess_image(img_path)
    text = pytesseract.image_to_string(img)
    print(text, type(text))
    return text
"""

import pytesseract
from PIL import Image, ImageEnhance, ImageFilter
import pandas as pd
import cv2
import numpy as np

# Définir le chemin de l'exécutable Tesseract
pytesseract.pytesseract.tesseract_cmd = 'C:\\Program Files\\Tesseract-OCR\\tesseract.exe'

def preprocess_image(img_path):
    '''Prétraitement de l'image'''
    img = Image.open(img_path)
    # Améliorer le contraste
    enhancer = ImageEnhance.Contrast(img)
    img = enhancer.enhance(2)
    # Convertir en niveaux de gris
    img = img.convert('L')
    # Appliquer un filtre de netteté
    img = img.filter(ImageFilter.SHARPEN)
    return img

def extract_text_as_table(img_path):
    '''Extraction du texte en tant que table'''
    img = preprocess_image(img_path)
    custom_config = r'--oem 3 --psm 6'
    text = pytesseract.image_to_string(img, config=custom_config)

    # Convertir le texte en DataFrame
    rows = text.split('\n')
    table_data = []
    for row in rows:
        if row.strip():  # Sauter les lignes vides
            table_data.append([cell if cell.strip() else "0" for cell in row.split()])

    df = pd.DataFrame(table_data)
    return df

def print_text(img_path):
    '''Affichage dans la console'''
    df = extract_text_as_table(img_path)
    #print(type(df))
    #print(df)
    return df

