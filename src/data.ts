import type {Project,Item} from './types';
export const projects:Project[]=[
 {id:'renault',name:'Renault SOVAB',customer:'Renault',pm:'Lucas',engineer:'Dongqi',status:'现场实施',progress:72,risk:'高',start:'2026-08-01',delivery:'2026-10-30',description:'RCS / WCS / PLC 联调及 AMR 现场交付'},
 {id:'auchan',name:'Auchan Phase 2',customer:'Auchan',pm:'Alice',engineer:'Eric',status:'技术验证',progress:45,risk:'中',start:'2026-08-18',delivery:'2026-11-15',description:'仓储 AMR 二期集成'},
 {id:'atlantic',name:'Atlantic',customer:'Atlantic',pm:'Bob',engineer:'Bin',status:'现场实施',progress:90,risk:'低',start:'2026-06-10',delivery:'2026-09-30',description:'产线物流自动化'},
 {id:'moulin',name:'Moulin Dumée',customer:'Moulin Dumée',pm:'David',engineer:'Eric',status:'需求分析',progress:28,risk:'严重',start:'2026-09-01',delivery:'2026-12-18',description:'项目范围与客户 IT 条件确认'}];
export const requirements:Item[]=[
 {id:'REQ-001',projectId:'renault',title:'A区至B区 Rack 自动搬运',owner:'Dongqi',status:'已确认',priority:'高',detail:'RCS Scheduling API + WCS Task Management + PLC Handshake'},
 {id:'REQ-002',projectId:'renault',title:'自动门联动与通行保护',owner:'Eric',status:'待客户确认',priority:'高',detail:'Door PLC 握手及超时处理'},
 {id:'REQ-003',projectId:'renault',title:'PDA 空满架交换任务',owner:'Lucas',status:'已确认',priority:'中',detail:'PDA → RTAS → RCS → ROBOT'}];
export const tests:Item[]=[
 {id:'TC-001',projectId:'renault',title:'Door Integration',owner:'Dongqi',status:'PASS',detail:'RCS → WCS → PLC → Door 全链路验证'},
 {id:'TC-002',projectId:'renault',title:'PLC Handshake Timeout',owner:'Eric',status:'FAIL',detail:'返回信号延迟超过设计值'},
 {id:'TC-003',projectId:'renault',title:'Robot Navigation Accuracy',owner:'Bin',status:'PASS',detail:'货架储位重复定位精度验证'},
 {id:'TC-004',projectId:'renault',title:'SICK Safety Zone',owner:'Dongqi',status:'BLOCKED',detail:'等待客户开放现场测试区域'}];
export const tasks:Item[]=[
 {id:'TSK-01',projectId:'renault',title:'完成 RCS API 验证',owner:'Dongqi',status:'进行中',date:'2026-09-11'},
 {id:'TSK-02',projectId:'renault',title:'SICK Safety Zone 测试',owner:'Eric',status:'阻塞',date:'2026-09-12'},
 {id:'TSK-03',projectId:'renault',title:'WCS 联调',owner:'Bin',status:'待处理',date:'2026-09-14'},
 {id:'TSK-04',projectId:'renault',title:'客户培训',owner:'Lucas',status:'待处理',date:'2026-09-18'}];
export const risks:Item[]=[
 {id:'RSK-01',projectId:'renault',title:'WCS API 尚未最终确认',owner:'Dongqi',status:'Open',priority:'严重',detail:'可能影响 FAT 日期'},
 {id:'RSK-02',projectId:'renault',title:'Door PLC 返回延迟',owner:'Eric',status:'处理中',priority:'高',detail:'已安排联合测试'},
 {id:'RSK-03',projectId:'auchan',title:'客户 IT 尚未提供 VLAN',owner:'Alice',status:'Open',priority:'高',detail:'影响服务器上线'}];
