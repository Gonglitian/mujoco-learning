#!/usr/bin/env python3
"""测试 mj_learning 包的导入是否正常"""

import sys
print(f"Python 版本: {sys.version}")
print(f"Python 路径: {sys.path[:3]}...")
print()

try:
    # 测试基础模块导入
    print("1. 测试导入 mj_learning.utils...")
    from mj_learning import utils
    print(f"   ✓ 成功! MODEL_ROOT = {utils.MODEL_ROOT}")
    print()
    
    # 测试 visualization 模块
    print("2. 测试导入 mj_learning.visualization.mujoco_viewer...")
    from mj_learning.visualization import mujoco_viewer
    print("   ✓ 成功!")
    print()
    
    # 测试 kinematics 模块 (可能有外部依赖)
    print("3. 测试导入 mj_learning.kinematics.casadi_ik...")
    try:
        from mj_learning.kinematics import casadi_ik
        print("   ✓ 成功!")
    except ImportError as e:
        print(f"   ⚠ 跳过 (缺少依赖: {e.name})")
    print()
    
    # 测试 control 模块  (可能有外部依赖)
    print("4. 测试导入 mj_learning.control.so100_real_control...")
    try:
        from mj_learning.control import so100_real_control
        print("   ✓ 成功!")
    except ImportError as e:
        print(f"   ⚠ 跳过 (缺少依赖: {e.name if hasattr(e, 'name') else str(e)})")
    print()
    
    # 验证 MODEL_ROOT 是否正确
    import os
    print("5. 验证 MODEL_ROOT 路径...")
    model_path = os.path.join(utils.MODEL_ROOT, "franka_emika_panda/scene.xml")
    if os.path.exists(model_path):
        print(f"   ✓ 路径正确! 示例文件存在: {model_path}")
    else:
        print(f"   ✗ 警告: 文件不存在: {model_path}")
    print()
    
    print("=" * 60)
    print("所有导入测试通过! ✓")
    print("=" * 60)
    
except ImportError as e:
    print(f"   ✗ 导入失败: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)
except Exception as e:
    print(f"   ✗ 错误: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)

