import pandas as pd
import numpy as np

df = pd.read_csv("titanic.csv")

print("===== INITIAL DATA PREVIEW =====")
print(df.head())

print("\n===== DATASET INFO =====")
print(df.info())

print("\n===== MISSING VALUES (BEFORE CLEANING) =====")
print(df.isnull().sum())

df['Age'].fillna(df['Age'].median(), inplace=True)

df['Embarked'].fillna(df['Embarked'].mode()[0], inplace=True)

if 'Cabin' in df.columns:
    df.drop(columns=['Cabin'], inplace=True)

rows_before = df.shape[0]
df.drop_duplicates(inplace=True)
rows_after = df.shape[0]

print(f"\nDuplicates removed: {rows_before - rows_after}")

df['Survived'] = df['Survived'].astype('category')
df['Pclass'] = df['Pclass'].astype('category')

def age_group(age):
    if age < 18:
        return 'Child'
    elif age < 60:
        return 'Adult'
    else:
        return 'Senior'

df['Age_Group'] = df['Age'].apply(age_group)

print("\n===== MISSING VALUES (AFTER CLEANING) =====")
print(df.isnull().sum())

print("\n===== FINAL DATASET INFO =====")
print(df.info())

print("\n===== FINAL DATA PREVIEW =====")
print(df.head())

df.to_csv("cleaned_data.csv", index=False)

print("\n✅ Cleaned dataset saved as 'cleaned_data.csv'")
