import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

df = pd.read_csv("house_prices_cleaned.csv")

print("Shape of dataset:", df.shape)
print("\nDataset Info:")
print(df.info())
print("\nFirst 5 rows:")
print(df.head())

print("\nDescriptive Statistics:")
print(df.describe())

missing_percent = (df.isnull().sum() / len(df)) * 100
missing_df = pd.DataFrame({
    'Column': missing_percent.index,
    'Missing_Percentage': missing_percent.values
})

print("\nMissing Value Percentage:")
print(missing_df)

numeric_cols = df.select_dtypes(include=np.number).columns

for col in numeric_cols:
    plt.figure(figsize=(10,4))

    plt.subplot(1,2,1)
    plt.hist(df[col], bins=30)
    plt.title(f'Histogram of {col}')

    plt.subplot(1,2,2)
    plt.boxplot(df[col], vert=False)
    plt.title(f'Boxplot of {col}')

    plt.tight_layout()
    plt.show()

outlier_flags = pd.DataFrame()

for col in numeric_cols:
    Q1 = df[col].quantile(0.25)
    Q3 = df[col].quantile(0.75)
    IQR = Q3 - Q1

    lower = Q1 - 1.5 * IQR
    upper = Q3 + 1.5 * IQR

    outlier_flags[col + "_outlier"] = ((df[col] < lower) | (df[col] > upper))

df['Outlier_Flag'] = outlier_flags.any(axis=1)

print("\nNumber of rows with outliers:", df['Outlier_Flag'].sum())

df_capped = df.copy()

for col in numeric_cols:
    Q1 = df[col].quantile(0.25)
    Q3 = df[col].quantile(0.75)
    IQR = Q3 - Q1

    lower = Q1 - 1.5 * IQR
    upper = Q3 + 1.5 * IQR

    df_capped[col] = np.where(df[col] < lower, lower,
                       np.where(df[col] > upper, upper, df[col]))

print("\nOutliers capped using IQR method.")

corr_matrix = df_capped[numeric_cols].corr()

print("\nCorrelation Matrix:")
print(corr_matrix)

df_capped.to_csv("cleaned_dataset.csv", index=False)
print("\nCleaned dataset saved as cleaned_dataset.csv")
