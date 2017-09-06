#!/bin/bash

tail -n10 reports/SentimentAnalysis_metrics_1483049786672.csv | awk -F, '{print $12}'
