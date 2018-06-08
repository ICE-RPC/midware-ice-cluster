
ZeroC ICE集群搭建

ICE安装目录: /home/apps/cpplibs/Ice-3.6.4/

ICE集群基本由registry(master, replication, ...) 和 icegridnode(多)组成。

registry:

registry的master和replication区别只是IceGrid.Registry.ReplicaName, master节点ReplicaName必须为Master，其它视为复本。ICE的registry只能master写，其它只读；所以在master挂掉后会存在服务配置信息不可更改，但是可读。


icegridnode:

通常会存在多台机器，每台机器上面启动一个icegridnode, 文件node.id指定了icegridnode的Name，一般文件内容为`hostname`(ctrl.sh会取hostname来操作当前文件夹下的icegridnode示例)


欢迎交流QQ群: 92799001
