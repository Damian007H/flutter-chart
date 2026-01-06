import 'dart:math' as math;

import 'package:intl/intl.dart';


/// 数字格式化工具库
/// -----------------------------------------------------------
/// |-------|------|---------------------|
/// | 四舍五入 | 保留 | formatRoundFixed |
/// | 四舍五入 | 去掉 | formatRoundStrip |
/// | 截断   | 保留 | formatTruncateFixed |
/// | 截断   | 去掉 | formatTruncateStrip |
/// -----------------------------------------------------------
class NumberUtil {
  /// 四舍五入，不去尾 0
  static String formatRoundFixed(Object value, int decimals) {
    final v = _parse(value);
    final rounded = double.parse(v.toStringAsFixed(decimals));
    return NumberFormat('#,##0.${'0' * decimals}').format(rounded);
  }

  /// 四舍五入，去尾 0
  static String formatRoundStrip(Object value, int decimals) {
    final v = _parse(value);
    final rounded = double.parse(v.toStringAsFixed(decimals));
    return NumberFormat('#,##0.${'#' * decimals}').format(rounded);
  }

  /// 直接截断，不去尾 0
  static String formatTruncateFixed(Object value, int decimals) {
    final v = _parse(value);
    final factor = math.pow(10, decimals);
    final truncated = (v * factor).truncate() / factor;
    return NumberFormat('#,##0.${'0' * decimals}').format(truncated);
  }

  /// 截断，去尾 0
  static String formatTruncateStrip(Object value, int decimals) {
    final v = _parse(value);
    final factor = math.pow(10, decimals);
    final truncated = (v * factor).truncate() / factor;
    return NumberFormat('#,##0.${'#' * decimals}').format(truncated);
  }

  static num _parse(Object? value) {
    if (value == null) return 0;
    if (value is num) {
      if (value.isNaN) return 0;
      return value;
    }
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  // 用最终展示的 double 值计算精度：
  // 小数第一位非0 -> 2位；第一位为0 -> 第一个非0起保留4位（非0+后3位）
  static int _calculateDecimalsFromDouble(double value) {
    if (value == 0) return 2;

    // 固定精度，避免科学计数法 & 浮点噪声
    final s = value.abs().toStringAsFixed(16);

    final dotIndex = s.indexOf('.');
    if (dotIndex == -1) return 2;

    // 找第一个非 0 的数字（有效位起点）
    int firstSignificantIndex = -1;
    for (int i = 0; i < s.length; i++) {
      final c = s[i];
      if (c != '0' && c != '.') {
        firstSignificantIndex = i;
        break;
      }
    }

    if (firstSignificantIndex == -1) return 2;

    // 找第 4 个有效数字的位置
    int significantCount = 0;
    int fourthSignificantIndex = -1;

    for (int i = firstSignificantIndex; i < s.length; i++) {
      final c = s[i];
      if (c == '.') continue;
      significantCount++;
      if (significantCount == 4) {
        fourthSignificantIndex = i;
        break;
      }
    }

    if (fourthSignificantIndex == -1) return 2;

    // 计算需要的小数位数
    int decimals = fourthSignificantIndex - dotIndex;
    return decimals < 2 ? 2 : decimals;
  }



  /// 2) 成交量/金额缩写：M / B / T，保留 2 位小数，返回：$3.45B，带汇率
  static String formatShortAmount(String? valueStr, {int decimals = 2}) {
    if (valueStr == null || valueStr.trim().isEmpty) return '--';
    final raw = double.tryParse(valueStr.trim());
    if (raw == null) return '--';

    //先换汇（用原始 USD）
    final converted = raw;

    final abs = converted.abs();
    double base;
    String suffix;

    //再判断数量级
    if (abs >= 1e15) {
      base = converted / 1e15;
      suffix = 'P';
    } else if (abs >= 1e12) {
      base = converted / 1e12;
      suffix = 'T';
    } else if (abs >= 1e9) {
      base = converted / 1e9;
      suffix = 'B';
    } else if (abs >= 1e6) {
      base = converted / 1e6;
      suffix = 'M';
    } else if (abs >= 1e3) {
      base = converted / 1e3;
      suffix = 'K';
    } else {
      base = converted;
      suffix = '';
    }

    return '${base.toStringAsFixed(decimals)}$suffix';
  }




  /// 3) 成交量/金额缩写：M / B / T，保留 2 位小数，返回：$3.45B，不带汇率
  static String formatShortAmountNoCurrency(String? valueStr, {int decimals = 2}) {
    if (valueStr == null || valueStr.trim().isEmpty) return '--';
    final v = double.tryParse(valueStr.trim());
    if (v == null) return '--';

    final abs = v.abs();
    String suffix;
    double base;

    if (abs >= 1e12) {
      base = v / 1e12;
      suffix = 'T';
    } else if (abs >= 1e9) {
      base = v / 1e9;
      suffix = 'B';
    } else if (abs >= 1e6) {
      base = v / 1e6;
      suffix = 'M';
    }  else if (abs >= 1e3) {
      base = v / 1e3;
      suffix = 'K';
    } else {
      base = v;
      suffix = '';
    }

    return '${base.toStringAsFixed(decimals)}$suffix';
  }

}
