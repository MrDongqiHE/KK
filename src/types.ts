export type Status='需求分析'|'技术验证'|'现场实施'|'已交付';
export type Project={id:string;name:string;customer:string;pm:string;engineer:string;status:Status;progress:number;risk:'低'|'中'|'高'|'严重';start:string;delivery:string;description:string};
export type Item={id:string;projectId:string;title:string;owner:string;status:string;priority?:string;date?:string;detail?:string};
