# -25-Fall-AI-application-in-food-nutrition-and-health-Curriculum-Assay
Coding backup : Sarcopenia Metabolomics
# 基于多方法整合的肌少症代谢标志物筛选

## 项目简介
本课题应用人工智能方法筛选肌少症相关代谢标志物，整合传统多元统计（PLS-DA）与机器学习算法（随机森林、Lasso回归、SVM）进行特征选择。

## 数据来源
- 公共数据集：Metabolomics Workbench ST001179
- 样本：10只小鼠（青年组5只，老年组5只）
- 代谢物：175个

## 代码结构
1. `01_data_preprocessing.R` - 数据清洗与预处理
2. `02_plsda_analysis.R` - PLS-DA分析与VIP筛选
3. `03_machine_learning.R` - 机器学习特征选择
   (请按照顺序运行代码！)

## 运行环境
- R version 4.5.2
- 关键R包：ropls, randomForest, glmnet, e1071, ggplot2

## 引用
[你的论文题目]，[你的名字]，[课程名称]，[年份]
