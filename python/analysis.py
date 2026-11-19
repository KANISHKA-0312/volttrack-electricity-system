"""
================================================================================
FOUNDATIONS OF DATA SCIENCE (25ITC31)
Scenario 14: Electricity Consumption Management and Energy Usage Analysis
Author: Kanishka K | Register No: 732925ITR044 | Class: 25IT3A
Institution: Velalar College of Engineering and Technology, Erode - 12
================================================================================
This script performs:
1. Data Ingestion & Database Simulation
2. Data Cleaning & Transformation (Missing values, Outliers via IQR, Typing)
3. Descriptive Statistics & Aggregations
4. High-Consumption Anomaly Detection
5. Generation of 5 Publication-Ready Charts (Matplotlib & Seaborn)
"""

import os
import shutil
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Set publication style
sns.set_theme(style="whitegrid", palette="muted")
plt.rcParams['font.sans-serif'] = 'Segoe UI', 'DejaVu Sans', 'Arial'
plt.rcParams['axes.edgecolor'] = '#cccccc'
plt.rcParams['axes.linewidth'] = 0.8

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_PATH = os.path.join(BASE_DIR, "data", "electricity_data.csv")
CHARTS_DIR = os.path.join(BASE_DIR, "charts")
ASSETS_DIR = os.path.join(os.path.dirname(BASE_DIR), "assets", "charts")

os.makedirs(CHARTS_DIR, exist_ok=True)
os.makedirs(ASSETS_DIR, exist_ok=True)


def load_and_preprocess_data():
    print("=" * 80)
    print("STEP 1: INGESTING & PREPROCESSING ELECTRICITY CONSUMPTION DATASET")
    print("=" * 80)

    if not os.path.exists(DATA_PATH):
        raise FileNotFoundError(f"Data file not found at: {DATA_PATH}")

    df = pd.read_csv(DATA_PATH)
    print(f"[OK] Ingested {len(df)} records from {DATA_PATH}")
    print(f"Columns: {list(df.columns)}")

    # 1. Missing Values Check & Treatment
    missing_counts = df.isnull().sum()
    print("\n[Missing Values Check]")
    print(missing_counts[missing_counts > 0] if missing_counts.sum() > 0 else "  No missing values detected. Clean dataset.")

    # 2. Duplicate Detection
    duplicates = df.duplicated(subset=['consumer_id', 'billing_month']).sum()
    print(f"\n[Duplicate Check] Duplicates on (consumer_id, billing_month): {duplicates}")

    # 3. Data Type Conversions
    df['reading_date'] = pd.to_datetime(df['reading_date'])
    df['connection_type'] = df['connection_type'].astype('category')
    df['payment_status'] = df['payment_status'].astype('category')

    # 4. Outlier Detection using IQR Method (Unit 4: Data Transformation & Outliers)
    q1 = df['units_consumed'].quantile(0.25)
    q3 = df['units_consumed'].quantile(0.75)
    iqr = q3 - q1
    lower_bound = q1 - 1.5 * iqr
    upper_bound = q3 + 1.5 * iqr

    df['is_outlier'] = (df['units_consumed'] < lower_bound) | (df['units_consumed'] > upper_bound)
    outlier_count = df['is_outlier'].sum()
    print(f"\n[Outlier Detection (IQR Method)]")
    print(f"  Q1: {q1:.2f} kWh | Q3: {q3:.2f} kWh | IQR: {iqr:.2f} kWh")
    print(f"  Upper Outlier Threshold: {upper_bound:.2f} kWh")
    print(f"  Detected High-Load Outliers (Heavy Industrial): {outlier_count} records")

    return df


def compute_descriptive_statistics(df):
    print("\n" + "=" * 80)
    print("STEP 2: DESCRIPTIVE SUMMARY STATISTICS (Unit 1, 25ITC31)")
    print("=" * 80)

    stats = df[['units_consumed', 'total_bill_amount', 'sanctioned_load_kw']].describe().T
    stats['median'] = df[['units_consumed', 'total_bill_amount', 'sanctioned_load_kw']].median()
    stats['skewness'] = df[['units_consumed', 'total_bill_amount', 'sanctioned_load_kw']].skew()
    print(stats[['mean', 'median', 'std', 'min', 'max', 'skewness']].round(2))

    print("\n--- Summary By Connection Type ---")
    conn_summary = df.groupby('connection_type', observed=True).agg(
        Consumer_Count=('consumer_id', 'nunique'),
        Total_Units=('units_consumed', 'sum'),
        Mean_Units=('units_consumed', 'mean'),
        Total_Revenue=('total_bill_amount', 'sum')
    ).round(2)
    print(conn_summary)
    return conn_summary


def generate_visualizations(df):
    print("\n" + "=" * 80)
    print("STEP 3: GENERATING SCIENTIFIC VISUALIZATIONS (Unit 5, 25ITC31)")
    print("=" * 80)

    # -------------------------------------------------------------------------
    # Chart 1: Monthly Consumption Trend (Time-Series Multi-line Chart)
    # -------------------------------------------------------------------------
    plt.figure(figsize=(10, 5.5), dpi=300)
    monthly_trend = df.groupby(['billing_month', 'connection_type'], observed=True)['units_consumed'].sum().reset_index()
    palette = {'Domestic': '#2563eb', 'Commercial': '#0891b2', 'Industrial': '#dc2626', 'Agricultural': '#16a34a'}

    sns.lineplot(
        data=monthly_trend,
        x='billing_month',
        y='units_consumed',
        hue='connection_type',
        marker='o',
        linewidth=2.5,
        markersize=8,
        palette=palette
    )
    plt.title("Monthly Electricity Consumption Trend by Connection Category\nVelalar College of Engineering and Technology - Scenario 14", fontsize=12, fontweight='bold', pad=12)
    plt.xlabel("Billing Month", fontsize=10, fontweight='bold')
    plt.ylabel("Total Energy Consumed (kWh)", fontsize=10, fontweight='bold')
    plt.legend(title="Connection Type", frameon=True)
    plt.tight_layout()
    chart1_path = os.path.join(CHARTS_DIR, "monthly_consumption_trend.png")
    plt.savefig(chart1_path)
    plt.close()
    print(f"[Chart 1 Generated] {chart1_path}")

    # -------------------------------------------------------------------------
    # Chart 2: Category-wise Distribution (Bar & Donut Combination)
    # -------------------------------------------------------------------------
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5.5), dpi=300)

    category_agg = df.groupby('connection_type', observed=True)['units_consumed'].sum()
    colors = ['#2563eb', '#0891b2', '#dc2626', '#16a34a']

    # Donut Chart
    wedges, texts, autotexts = ax1.pie(
        category_agg,
        labels=category_agg.index,
        autopct='%1.1f%%',
        startangle=140,
        colors=colors,
        wedgeprops=dict(width=0.4, edgecolor='white', linewidth=2),
        pctdistance=0.75
    )
    plt.setp(autotexts, size=9, weight="bold", color="white")
    ax1.set_title("Energy Consumption Share (% kWh)", fontsize=11, fontweight='bold')

    # Billed Revenue Bar Chart
    rev_agg = df.groupby('connection_type', observed=True)['total_bill_amount'].sum() / 1000
    bars = ax2.bar(rev_agg.index, rev_agg.values, color=colors, width=0.55, edgecolor='#333333', linewidth=0.8)
    ax2.set_title("Total Billed Revenue (Thousand INR)", fontsize=11, fontweight='bold')
    ax2.set_ylabel("Revenue (₹ '000)", fontsize=10, fontweight='bold')
    ax2.set_xlabel("Connection Type", fontsize=10, fontweight='bold')
    for bar in bars:
        height = bar.get_height()
        ax2.annotate(f"₹{height:.1f}k",
                     xy=(bar.get_x() + bar.get_width() / 2, height),
                     xytext=(0, 3), textcoords="offset points",
                     ha='center', va='bottom', fontsize=9, fontweight='bold')

    fig.suptitle("Electricity Distribution & Revenue Analysis (Author: Kanishka K)", fontsize=13, fontweight='bold')
    plt.tight_layout()
    chart2_path = os.path.join(CHARTS_DIR, "connection_type_distribution.png")
    plt.savefig(chart2_path)
    plt.close()
    print(f"[Chart 2 Generated] {chart2_path}")

    # -------------------------------------------------------------------------
    # Chart 3: Top 10 High Consumption Consumers (Alert Horizon)
    # -------------------------------------------------------------------------
    plt.figure(figsize=(11, 6), dpi=300)
    top_consumers = df.groupby(['consumer_number', 'name', 'connection_type'], observed=True)['units_consumed'].mean().reset_index()
    top_consumers = top_consumers.sort_values(by='units_consumed', ascending=True).tail(10)

    bar_colors = ['#dc2626' if t == 'Industrial' else '#f59e0b' if t == 'Commercial' else '#2563eb' 
                  for t in top_consumers['connection_type']]

    y_pos = range(len(top_consumers))
    bars = plt.barh(y_pos, top_consumers['units_consumed'], color=bar_colors, edgecolor='#222222', height=0.65)
    plt.yticks(y_pos, [f"{row['name']} ({row['consumer_number']})" for _, row in top_consumers.iterrows()], fontsize=9)
    plt.xlabel("Average Monthly Consumption (kWh)", fontsize=10, fontweight='bold')
    plt.title("Top High-Consumption Consumers Identification (Scenario 14 Requirement 5)", fontsize=12, fontweight='bold', pad=12)

    for bar in bars:
        w = bar.get_width()
        plt.text(w + 50, bar.get_y() + bar.get_height()/2, f"{w:,.0f} kWh", va='center', ha='left', fontsize=8.5, fontweight='bold')

    plt.tight_layout()
    chart3_path = os.path.join(CHARTS_DIR, "top_high_consumers.png")
    plt.savefig(chart3_path)
    plt.close()
    print(f"[Chart 3 Generated] {chart3_path}")

    # -------------------------------------------------------------------------
    # Chart 4: Consumption Distribution & Outlier Detection (Histogram + Boxplot)
    # -------------------------------------------------------------------------
    fig, (ax_box, ax_hist) = plt.subplots(2, 1, figsize=(10, 6.5), sharex=True, 
                                          gridspec_kw={'height_ratios': [0.25, 0.75]}, dpi=300)

    sns.boxplot(x=df['units_consumed'], ax=ax_box, color='#38bdf8', fliersize=5)
    ax_box.set(xlabel='')
    ax_box.set_title("Exploratory Data Analysis: Consumption Spread & Outliers", fontsize=12, fontweight='bold')

    sns.histplot(df['units_consumed'], kde=True, ax=ax_hist, color='#2563eb', bins=18, edgecolor='black')
    ax_hist.set_xlabel("Units Consumed (kWh)", fontsize=10, fontweight='bold')
    ax_hist.set_ylabel("Frequency Count", fontsize=10, fontweight='bold')
    plt.tight_layout()
    chart4_path = os.path.join(CHARTS_DIR, "consumption_distribution_and_outliers.png")
    plt.savefig(chart4_path)
    plt.close()
    print(f"[Chart 4 Generated] {chart4_path}")

    # -------------------------------------------------------------------------
    # Chart 5: Correlation Heatmap (Units, Load, Charges, Total Bill)
    # -------------------------------------------------------------------------
    plt.figure(figsize=(7.5, 6), dpi=300)
    numeric_cols = df[['sanctioned_load_kw', 'previous_reading', 'current_reading', 'units_consumed', 'total_bill_amount']]
    corr = numeric_cols.corr()

    sns.heatmap(
        corr,
        annot=True,
        cmap='Blues',
        fmt=".3f",
        linewidths=1.2,
        cbar_kws={'label': 'Pearson Correlation Coefficient'}
    )
    plt.title("Feature Correlation Matrix Heatmap\n(25ITC31 Exploratory Data Analysis)", fontsize=11, fontweight='bold', pad=12)
    plt.tight_layout()
    chart5_path = os.path.join(CHARTS_DIR, "correlation_heatmap.png")
    plt.savefig(chart5_path)
    plt.close()
    print(f"[Chart 5 Generated] {chart5_path}")

    # Mirror charts to Web App assets folder
    for f in os.listdir(CHARTS_DIR):
        if f.endswith('.png'):
            shutil.copy2(os.path.join(CHARTS_DIR, f), os.path.join(ASSETS_DIR, f))
    print(f"\n[OK] All 5 scientific charts mirrored to web app assets at: {ASSETS_DIR}")


def main():
    print("=" * 80)
    print("VELALAR COLLEGE OF ENGINEERING AND TECHNOLOGY | IT DEPARTMENT")
    print("25ITC31 - FOUNDATIONS OF DATA SCIENCE: AUTOMATED PIPELINE")
    print("Student: Kanishka K | Register No: 732925ITR044 | Class: 25IT3A")
    print("=" * 80)

    df = load_and_preprocess_data()
    compute_descriptive_statistics(df)
    generate_visualizations(df)

    print("\n" + "=" * 80)
    print(">>> DATA SCIENCE PIPELINE EXECUTED SUCCESSFULLY WITH 5 VISUALIZATIONS.")
    print("=" * 80)


if __name__ == "__main__":
    main()
