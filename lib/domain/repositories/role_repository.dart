import 'package:dartz/dartz.dart';
import 'package:supermarket/domain/entities/role.dart';

abstract class RoleRepository {
  Future<Either<String, List<Role>>> getAllRoles();
  Future<Either<String, Role>> getRoleById(String id);
  Future<Either<String, Role>> createRole(Role role);
  Future<Either<String, Role>> updateRole(Role role);
  Future<Either<String, bool>> deleteRole(String id);
  Future<Either<String, Role>> assignPermissions(String roleId, Set<Permission> permissions);
  Future<Either<String, bool>> hasPermission(String userId, Permission permission);
  Future<Either<String, Set<Permission>>> getUserPermissions(String userId);
}
