import { HttpStatus } from '@nestjs/common';
import { Response } from 'express';

export const responseData = (
  res: Response,
  resData: any,
  statusCode?: number,
) => {
  if (resData && statusCode) {
    return res.status(statusCode).send(resData);
  }
  return res.status(HttpStatus.OK).send(resData);
};
