#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon May 12 18:47:34 2025

@author: wangxiaoyu
"""

import argparse
from collections import Counter, defaultdict

def get_consensus_assignment(assignments):
    """
    计算共识分类从一个分类列表中
    """
    num_input_assignments = len(assignments)
    consensus_assignment = []
    num_levels = min(len(a) for a in assignments)  # 获取最小分类层级数

    # 遍历每个分类层级
    for level in range(num_levels):
        current_level_assignments = Counter(tuple(e[:level + 1]) for e in assignments)
        tax, max_count = current_level_assignments.most_common(1)[0]
        max_consensus_fraction = max_count / num_input_assignments

        # 如果共识比例大于等于51%，则添加到共识分类中
        if max_consensus_fraction >= 0.51:
            consensus_assignment.append((tax[-1], max_consensus_fraction))
        else:
            break

    # 根据共识分类深度确定最终结果
    consensus_assignment_depth = len(consensus_assignment)
    if consensus_assignment_depth > 0:
        assignment_result = [a[0] for a in consensus_assignment]
        consensus_fraction_result = consensus_assignment[-1][1]
    else:
        assignment_result = ['Unassigned']
        consensus_fraction_result = 1.0

    return assignment_result, consensus_fraction_result, num_input_assignments


def load_taxonomy(file_path):
    """
    加载分类信息到字典
    """
    id_to_taxonomy = {}
    with open(file_path) as pg:
        for line in pg:
            p_list = line.strip().split('\t')
            id_to_taxonomy[p_list[0]] = p_list[1]
    return id_to_taxonomy


def process_uc_file(uc_file_path, id_to_taxonomy):
    """
    处理uc文件，提取分类信息
    """
    results = defaultdict(list)
    with open(uc_file_path) as uc:
        for line in uc:
            line = line.strip()
            if line.startswith('#') or line == "":
                continue
            elif line.startswith('H'):
                fields = line.split('\t')
                query_id = fields[8].split()[0]
                subject_id = fields[9].split()[0]
                tax = id_to_taxonomy[subject_id].split(';')
                results[query_id].append(tax)
            elif line.startswith('N'):
                fields = line.split('\t')
                query_id = fields[8].split()[0]
                results[query_id].append([])
    return results


def save_results(output_file_path, query_to_assignments):
    """
    将结果保存到文件
    """
    with open(output_file_path, 'w') as of:
        for seq_id, (assignment, consensus_fraction, n) in query_to_assignments.items():
            assignment_str = ';'.join(assignment)
            of.write(f'{seq_id}\t{assignment_str}\t{consensus_fraction:.2f}\t{n}\n')


def main():
    # 解析命令行参数
    parser = argparse.ArgumentParser(description='Calculate consensus taxonomic assignments from UC file .')
    parser.add_argument('-t', '--taxonomy', required=True, help='Path to the taxonomy file .')
    parser.add_argument('-u', '--uc', required=True, help='Path to the UC file.')
    parser.add_argument('-o', '--output', required=True, help='Path to the output file .')
    args = parser.parse_args()

    # 加载分类信息
    id_to_taxonomy = load_taxonomy(args.taxonomy)

    # 处理uc文件
    results = process_uc_file(args.uc, id_to_taxonomy)

    # 计算共识分类
    query_to_assignments = {query_id: get_consensus_assignment(assignments) for query_id, assignments in results.items()}

    # 保存结果
    save_results(args.output, query_to_assignments)

if __name__ == "__main__":
    main()