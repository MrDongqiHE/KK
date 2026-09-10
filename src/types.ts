export type Project={id:string;name:string;customer:string;status:string;progress:number;risk:string;start_date?:string|null;delivery_date?:string|null;description:string|null;created_at?:string;pm?:string;engineer?:string;start?:string;delivery?:string};
export type Item={id:string;projectId:string;title:string;status:string;priority?:string;detail?:string;owner?:string;date?:string};
