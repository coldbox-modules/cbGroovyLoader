<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Collab-Todo Nightly Report for ${String.format('%tA %<tB %<te %<tY', date)}</title>
</head>

<body bgcolor="#FFFFFF" style="margin:0;padding:0;">
  <div style="padding: 22px 20px 40px 20px;background-color:#FFFFFF;">
    <table width="568" border="0" cellspacing="0" cellpadding="1" bgcolor="#FFFFFF" align="center">
      <tr>
        <td>
          Dear ${user?.firstName} ${user?.lastName},
          <p />
          Please find your attached nightly report for ${String.format('%tA %<tB %<te %<tY', date)}.
        </td>
      </tr>
    </table>

    <table width="560" border="0" cellspacing="0" cellpadding="0" align="center">
      <tr valign="top">
        <td width="560" style="padding:15px 23px 10px 23px;">
          <p style="font-family: Geneva, Verdana, Arial, Helvetica, sans-serif; font-size:9px; color:#999;">
            &copy; 2008 Beginning Groovy and Grails by Christopher Judd, Joseph Faisal Nusairat, and James Shingler
          </p>
        </td>
      </tr>
    </table>
  </div>
</body>
</html>