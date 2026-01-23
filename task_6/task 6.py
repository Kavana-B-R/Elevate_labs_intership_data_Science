import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("cleaned_data.csv")

print("Dataset Loaded Successfully")
print(df.head())

gender_survival = df.groupby("Sex")["Survived"].sum()

plt.figure(figsize=(6,4))
plt.bar(gender_survival.index, gender_survival.values)
plt.title("Survivors by Gender")
plt.xlabel("Gender")
plt.ylabel("Number of Survivors")
plt.grid(axis="y")
plt.show()

age_survival = df.groupby("Age")["Survived"].mean()

plt.figure(figsize=(7,4))
plt.plot(age_survival.index, age_survival.values)
plt.title("Survival Rate by Age")
plt.xlabel("Age")
plt.ylabel("Survival Rate")
plt.grid()
plt.show()

plt.figure(figsize=(6,4))
plt.hist(df["Fare"], bins=10)
plt.title("Fare Distribution")
plt.xlabel("Fare")
plt.ylabel("Frequency")
plt.grid()
plt.show()

plt.figure(figsize=(6,4))
plt.scatter(df["Age"], df["Fare"])
plt.title("Age vs Fare")
plt.xlabel("Age")
plt.ylabel("Fare")
plt.grid()
plt.show()

print("All charts generated successfully")
