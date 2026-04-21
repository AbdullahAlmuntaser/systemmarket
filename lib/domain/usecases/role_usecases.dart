import 'package:dartz/dartz.dart';
import 'package:supermarket/domain/entities/role.dart';
import 'package:supermarket/domain/repositories/role_repository.dart';

class GetRoles {
  final RoleRepository repository;

  GetRoles(this.repository);

  Future<Either<String, List<Role>>> call() async {
    return await repository.getAllRoles();
  }
}

class GetRoleById {
  final RoleRepository repository;

  GetRoleById(this.repository);

  Future<Either<String, Role>> call(String id) async {
    return await repository.getRoleById(id);
  }
}

class CreateRole {
  final RoleRepository repository;

  CreateRole(this.repository);

  Future<Either<String, Role>> call(Role role) async {
    return await repository.createRole(role);
  }
}

class UpdateRole {
  final RoleRepository repository;

  UpdateRole(this.repository);

  Future<Either<String, Role>> call(Role role) async {
    return await repository.updateRole(role);
  }
}

class DeleteRole {
  final RoleRepository repository;

  DeleteRole(this.repository);

  Future<Either<String, bool>> call(String id) async {
    return await repository.deleteRole(id);
  }
}

class AssignPermissions {
  final RoleRepository repository;

  AssignPermissions(this.repository);

  Future<Either<String, Role>> call(String roleId, Set<Permission> permissions) async {
    return await repository.assignPermissions(roleId, permissions);
  }
}

class HasPermission {
  final RoleRepository repository;

  HasPermission(this.repository);

  Future<Either<String, bool>> call(String userId, Permission permission) async {
    return await repository.hasPermission(userId, permission);
  }
}

class GetUserPermissions {
  final RoleRepository repository;

  GetUserPermissions(this.repository);

  Future<Either<String, Set<Permission>>> call(String userId) async {
    return await repository.getUserPermissions(userId);
  }
}
