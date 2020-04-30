Attribute VB_Name = "SSFun"
Option Explicit
'-------------------------------------------------------------------------
'��Ʈ���� ���缿�� ��ġ�� �����Ѵ�.
'Arg : SS         ���Ʈ
'      RIdx, CIdx �̵��� ���� ��ġ
'      Scl_Gb     �̵��ɼ�(��Ʈ���� �ǿ������� ���� �ϴ� �ɼ�)
'-------------------------------------------------------------------------
Public Sub gsubSS_CellMove(ss As Control, RIdx As Long, CIdx As Long, Scl_Gb As Boolean)
    ss.Row = RIdx
    ss.Col = CIdx
    
    ss.Position = 0     'SS_POSITION_UPPER_LEFT
    ss.Action = 0       'SS_ACTION_ACTIVE_CELL
    If (Scl_Gb) Then
        ss.Action = 1   'SS_ACTION_GOTO_CELL
    End If
End Sub
'-------------------------------------------------------------------------
'��Ʈ���� �����ȿ����� ���ڻ����� �����Ѵ�.
'Arg : SS          ���Ʈ
'      R1,C1,R2,C2 ����
'      Color       ����
'-------------------------------------------------------------------------
Public Sub gsubSS_SetForeColor(ss As Control, Color, R1 As Long, C1 As Long, Optional R2 As Long, Optional C2 As Long)
    Dim Old_Row As Long, old_col As Long
    
    Old_Row = ss.Row: old_col = ss.Col
    ss.Row = R1
    ss.Col = C1
    If (Not IsMissing(R2)) Then
        ss.Row2 = R2
        ss.Col2 = C2
        ss.BlockMode = True
        ss.ForeColor = Color
        ss.BlockMode = False
    Else
        ss.ForeColor = Color
    End If
    ss.Row = Old_Row: ss.Col = old_col
End Sub
'-------------------------------------------------------------------------
'��Ʈ���� �����ȿ����� �������� �����Ѵ�.
'Arg : SS          ���Ʈ
'      R1,C1,R2,C2 ����
'      Color       ����
'-------------------------------------------------------------------------
Public Sub gsubSS_SetBackColor(ss As Control, Color, R1 As Long, C1 As Long, Optional R2 As Long, Optional C2 As Long)
    Dim Old_Row As Long, old_col As Long
    
    Old_Row = ss.Row: old_col = ss.Col
    ss.Row = R1
    ss.Col = C1
    If (Not IsMissing(R2)) Then
        ss.Row2 = R2
        ss.Col2 = C2
        ss.BlockMode = True
        ss.BackColor = Color
        ss.BlockMode = False
    Else
        ss.BackColor = Color
    End If
    ss.Row = Old_Row: ss.Col = old_col
End Sub
'-------------------------------------------------------------------------
'��Ʈ���� �ش翵���� Formula�� ����
'Arg : R1,C1,R2,C2       ����
'-------------------------------------------------------------------------
Public Function gfunSS_GetFArea(R1 As Long, C1 As Long, R2 As Long, C2 As Long)
    Dim sTemp As String
    
    gfunSS_GetFArea = gfunSS_GetFPos(R1, C1) & ":" & gfunSS_GetFPos(R2, C2)
End Function
'-------------------------------------------------------------------------
'��Ʈ���� �ش缿�� Formula�� ����
'Arg : R1,C1       ��
'-------------------------------------------------------------------------
Public Function gfunSS_GetFPos(R1 As Long, C1 As Long)
    Dim sTemp As String
    
    gfunSS_GetFPos = Chr(C1 + 64) & Format(R1, "##")
End Function
'-------------------------------------------------------------------------
'��Ʈ���� �ش缿�� Fomula�� �����Ѵ�.
'Arg : SS          ���Ʈ
'      R1,C1       ����
'      sTemp       Ư��
'-------------------------------------------------------------------------
Public Sub gsubSS_SetFomula(ss As Control, R1 As Long, C1 As Long, sTemp)
    Dim Old_Row As Long, old_col As Long
    
    Old_Row = ss.Row: old_col = ss.Col
    ss.Row = R1
    ss.Col = C1
    ss.Formula = sTemp
    'ss.Action = 11
    ss.Row = Old_Row: ss.Col = old_col
End Sub
'-------------------------------------------------------------------------
'��Ʈ���� �ڷḦ Ŭ�����Ѵ�.
'Arg : SS          ���Ʈ
'      sText       Ŭ����� ����(Optional)
'      R1,C1,R2,C2 ����(Optional)
'-------------------------------------------------------------------------
Public Sub gsubSS_Clear(ss As Control, Optional sText, Optional R1, Optional C1, _
                                       Optional R2, Optional C2)
    Dim Old_Row As Long, old_col As Long
    
    Old_Row = ss.Row: old_col = ss.Col
    If (IsMissing(R1)) Then
        ss.Row = ss.StartingRowNumber
        ss.Col = ss.StartingColNumber
        ss.Row2 = ss.MaxRows
        ss.Col2 = ss.MaxCols
    Else
        ss.Row = R1
        ss.Col = C1
        ss.Row2 = R2
        ss.Col2 = C2
    End If
    ss.BlockMode = True
    If (IsMissing(sText)) Then
        ss.Action = 3 'SS_ACTION_CLEAR
    Else
        ss.Text = sText
    End If
    ss.BlockMode = False
    ss.Row = Old_Row: ss.Col = old_col
End Sub
'-------------------------------------------------------------------------
'��Ʈ�� Lock ��带 ���� �� �����Ѵ�.
'Arg : SS          ���Ʈ
'      bMode       True/False
'      R1,C1,R2,C2 ����(Optional)
'-------------------------------------------------------------------------
Public Sub gsubSS_Lock(ss As Control, bMode, Optional R1 As Long, Optional C1 As Long, _
                                             Optional R2 As Long, Optional C2 As Long)
    Dim Old_Row As Long, old_col As Long
    
    Old_Row = ss.Row: old_col = ss.Col
    
    If (IsMissing(R1)) Then
        ss.Row = ss.StartingRowNumber
        ss.Col = ss.StartingColNumber
        ss.Row2 = ss.MaxRows
        ss.Col2 = ss.MaxCols
    ElseIf (IsMissing(R2)) Then
        ss.Row = R1
        ss.Col = C1
        ss.Row2 = R1
        ss.Col2 = C1
    Else
        ss.Row = R1
        ss.Col = C1
        ss.Row2 = R2
        ss.Col2 = C2
    End If
    
    ss.Protect = True
    ss.BlockMode = True
    ss.Lock = bMode
    ss.BlockMode = False
    ss.Row = Old_Row: ss.Col = old_col
    
End Sub
'-------------------------------------------------------------------------
'��Ʈ�� �籸���ϰ� Clear�Ѵ�.
'Arg : SS     ���Ʈ
'      MR, MC ������� �ִ밪(Optional)
'-------------------------------------------------------------------------
Public Sub gsubSS_SetMax(ss As Control, Optional MR As Long, Optional MC As Long)
    If (Not IsMissing(MR)) Then ss.MaxRows = MR
    If (Not IsMissing(MC)) Then ss.MaxCols = MC
    If (Not IsMissing(MR)) And (Not IsMissing(MC)) And (MR > 0) Then
        Call gsubSS_Clear(ss, "")
    ElseIf (Not IsMissing(MR)) And (MR > 0) Then
        Call gsubSS_Clear(ss, "", MR, 1, MR, ss.MaxCols)
    ElseIf (Not IsMissing(MC)) And (MR > 0) Then
        Call gsubSS_Clear(ss, "", 1, MC, ss.MaxRows, MC)
    End If
End Sub
'-------------------------------------------------------------------------
'��Ʈ�� ���� �߰��Ѵ�
'Arg : SS         ���Ʈ
'      sText      ���� ����(Optional)
'      Row_ID     �߰��� ���ȣ(Optional)
'-------------------------------------------------------------------------
Public Sub gsubSS_AddRow(ss As Control, Optional row_id As Long)
    If (IsMissing(row_id)) Then
        ss.MaxRows = ss.MaxRows + 1
        
        Call gsubSS_CellMove(ss, ss.MaxRows, 1, True)
        'SS.Row = SS.MaxRows
        'SS.Position = 4    'SS_POSITION_UPPER_LEFT
        'SS.Action = 0       'SS_ACTION_ACTIVE_CELL
        'SS.Action = 1
    Else
        ss.MaxRows = ss.MaxRows + 1
        ss.Row = row_id + 1
        ss.Action = 7       'SS_ACTION_INSERT_ROW
        Call gsubSS_CellMove(ss, ss.Row, 1, False)
    End If
End Sub
'-------------------------------------------------------------------------
'��Ʈ�� ���� �����Ѵ�
'Arg : SS         ���Ʈ
'-------------------------------------------------------------------------
Public Sub gsubSS_DelRow(ss As Control, Optional R1 As Long)
    Dim row_id As Long
    
    If (ss.MaxRows = 0) Then
        Call gsubSS_Clear(ss, " ", 1, 0, 1, ss.MaxCols)
    Else
        If (IsMissing(R1)) Then
            row_id = ss.ActiveRow
        Else
            row_id = R1
        End If
        ss.Row = row_id
        ss.Action = 5       'SS_ACTION_DELETE_ROW
        If (row_id = ss.MaxRows) Then Call gsubSS_CellMove(ss, ss.MaxRows - 1, ss.Col, True)
        ss.MaxRows = ss.MaxRows - 1
    End If
    
        
        
        
End Sub
'-------------------------------------------------------------------------
'��Ʈ�� ���� �߰��Ѵ�
'Arg : SS         ���Ʈ
'      sText      ��������(Optional)
'      Col_ID     �߰��� ����ȣ(Optional)
'-------------------------------------------------------------------------
Public Sub gsubSS_AddCol(ss As Control, Optional sText, Optional col_id As Long)
    If (IsMissing(col_id)) Then
        ss.MaxCols = ss.MaxCols + 1
        ss.Col = ss.MaxCols
        
        ss.Position = 4    'SS_POSITION_UPPER_LEFT
        ss.Action = 0       'SS_ACTION_ACTIVE_CELL
    Else
        ss.MaxCols = ss.MaxCols + 1
        ss.Col = col_id
        ss.Action = 6       'SS_ACTION_INSERT_COL
        Call gsubSS_CellMove(ss, ss.Row, ss.Col, True)
    End If
    If (IsMissing(sText)) Then
        Call gsubSS_SetText(ss, 0, ss.Col)
    Else
        Call gsubSS_SetText(ss, 0, ss.Col, sText)
    End If
End Sub
'-------------------------------------------------------------------------
'��Ʈ�� ���� �����
'Arg : SS         ���Ʈ
'-------------------------------------------------------------------------
Public Sub gsubSS_HiddenRow(ss As Control, Optional R1 As Long)
    Dim row_id As Long
    
    If (IsMissing(R1)) Then
        row_id = ss.ActiveRow
        If (row_id < 1) Then Exit Sub
        ss.Row = row_id
    Else
        row_id = ss.ActiveRow
        ss.Row = R1
    End If
    ss.RowHidden = True
End Sub
'-------------------------------------------------------------------------
'��Ʈ�� ���� �����
'Arg : SS         ���Ʈ
'-------------------------------------------------------------------------
Public Sub gsubSS_HiddenCol(ss As Control, C1 As Long, Optional Value)
    Dim row_id As Long, old_col As Long
    
    old_col = ss.Col
    ss.Col = C1
    If IsMissing(Value) Then
        ss.ColHidden = True
    Else
        ss.ColHidden = Value
    End If
    
    ss.Col = old_col
    
End Sub
'-------------------------------------------------------------------------
'��Ʈ�� ���� �����Ѵ�
'Arg : SS         ���Ʈ
'-------------------------------------------------------------------------
Public Sub gsubSS_DelCol(ss As Control)
    Dim col_id As Integer
    
    If (ss.MaxCols = 1) Then
        Call gsubSS_Clear(ss, " ", 0, 1, ss.MaxRows, 1)
    Else
        col_id = ss.Col
        ss.Action = 4       'SS_ACTION_DELETE_COL
        If (col_id = ss.MaxCols) Then Call gsubSS_CellMove(ss, ss.Row, ss.MaxCols - 1, True)
    End If
End Sub

'-------------------------------------------------------------------------
'�ش缿�� ���ڸ� �����Ѵ�
'Arg : SS     ���Ʈ
'      R1, C1 �����
'      sText  ������ ���ڿ�(Optional)
'-------------------------------------------------------------------------
Public Sub gsubSS_SetText(ss As Control, R1 As Long, C1 As Long, Optional sText)
    Dim Old_Row As Long, old_col As Long, i As Long
    
    Old_Row = ss.Row: old_col = ss.Col
    ss.Row = R1: ss.Col = C1
    If (Not IsMissing(sText)) Then
        If (IsNull(sText)) Then
            ss.Text = ""
        Else
            ss.Text = sText
        End If
    Else
        ss.Text = ""
    End If
    ss.Row = Old_Row: ss.Col = old_col
End Sub
'-------------------------------------------------------------------------
'�ش��޺����� ���ڿ��� ����Ѵ�
'Arg : SS     ���Ʈ
'      R1, C1 �����
'      sText  ������ ���ڿ�(Optional)
'-------------------------------------------------------------------------
Public Sub gsubSS_SetComboList(ss As Control, R1 As Long, C1 As Long, Optional sText)
    Dim Old_Row As Long, old_col As Long, i As Long
    
    Old_Row = ss.Row: old_col = ss.Col
    ss.Row = R1: ss.Col = C1

    If (IsMissing(sText)) Then
        ss.TypeComboBoxList = ""
    Else
        If (IsNull(sText)) Then
            ss.TypeComboBoxList = ""
        Else
            ss.TypeComboBoxList = sText
        End If
    End If
    ss.Row = Old_Row: ss.Col = old_col
End Sub
'-------------------------------------------------------------------------
'�ش缿�� ���ڸ� �����Ѵ�
'Arg     : SS     ���Ʈ
'          R1, C1 �����
'Return  : �ش� ����
'-------------------------------------------------------------------------
Public Function gfunSS_GetText(ss As Control, R1 As Long, C1 As Long)
    Dim Old_Row As Long, old_col As Long
    
    Old_Row = ss.Row: old_col = ss.Col
    ss.Row = R1: ss.Col = C1
    If (ss.CellType = 2) Or (ss.CellType = 3) Then '3:integer 2:float
        If (Len(Trim(ss.Text)) = 0) Then
            gfunSS_GetText = "0"
        Else
            If ss.CellType = 2 Then
                Select Case ss.TypeFloatDecimalPlaces
                    Case 0
                        gfunSS_GetText = Format(ss.Text, "####################0")
                    Case 1
                        gfunSS_GetText = Format(ss.Text, "####################0.0")
                    Case 2
                        gfunSS_GetText = Format(ss.Text, "####################0.00")
                    Case 3
                        gfunSS_GetText = Format(ss.Text, "####################0.000")
                    Case 4
                        gfunSS_GetText = Format(ss.Text, "####################0.0000")
                    Case Else
                        gfunSS_GetText = Format(ss.Text, "####################0")
                End Select
            Else
                gfunSS_GetText = Format(ss.Text, "####################0")
            End If
        End If
    ElseIf ss.CellType = 0 Then
        If IsDate(ss.Text) Then
            gfunSS_GetText = Format(ss.Text, "yyyymmdd")
        Else
            gfunSS_GetText = ""
        End If
    Else
        gfunSS_GetText = ss.Text
    End If
    ss.Row = Old_Row: ss.Col = old_col
End Function

'-------------------------------------------------------------------------
'�ش缿�� ���� Sum �Ѵ�
'Arg     : SS     ���Ʈ
'          C1,C2  ���
'Return  : Sum Value.
'-------------------------------------------------------------------------
Public Function gfunSS_ColTotal(ss As Control, C1 As Long, C2 As Long) As Double
    Dim i As Long
    Dim dblTotal As Double
    Dim dblQty As Double
    Dim dblPrice As Double
    
    dblTotal = 0
    ss.Col = C1
    For i = 1 To ss.MaxRows
        ss.Row = i
        ss.Col = C1
        dblQty = CDbl(Format(ss.Text, "####################0.0000"))
        ss.Col = C2
        dblPrice = CDbl(Format(ss.Text, "####################0.0000"))
        
        dblTotal = dblTotal + dblPrice * dblQty
    Next i

    gfunSS_ColTotal = dblTotal
End Function

'-------------------------------------------------------------------------
'�ش缿�� Add������ �����Ѵ�.
'Arg : SS     ���Ʈ
'      R1, C1 �����
'      sText  ������ ������ ���ڿ�
'-------------------------------------------------------------------------
Public Sub gsubSS_AddText(ss As Control, R1 As Long, C1 As Long, sText)
    Dim Old_Row As Long, old_col As Long
    
    Old_Row = ss.Row: old_col = ss.Col
    ss.Row = R1: ss.Col = C1
    ss.Text = CStr(CLng(gfunSS_GetText(ss, R1, C1)) + CLng(sText))
    ss.Row = Old_Row: ss.Col = old_col
End Sub

'-------------------------------------------------------------------------
'�ش缿�� Sub������ �����Ѵ�.
'Arg : SS     ���Ʈ
'      R1, C1 �����
'      sText  ������ ������ ���ڿ�
'-------------------------------------------------------------------------
Public Sub gsubSS_SubText(ss As Control, R1 As Long, C1 As Long, sText)
    Dim Old_Row As Long, old_col As Long
    
    Old_Row = ss.Row: old_col = ss.Col
    ss.Row = R1: ss.Col = C1
    ss.Text = CStr(CLng(gfunSS_GetText(ss, R1, C1)) - CLng(sText))
    ss.Row = Old_Row: ss.Col = old_col
End Sub

'-------------------------------------------------------------------------
'Query����� Spread Sheet�� Display�Ѵ�.
'Arg : ss     ���Ʈ
'-------------------------------------------------------------------------
'Public Sub gsubSS_Query(Query$, ss As Control)
'
'    Dim i&, j&, RetCode%, OldMousePointer%, RetCols%
'    Dim szColName$, cbColNameMax%, pcbColName%, pfSqlType%, pcbColDef&, pibScale%, pfNullable%
'    Dim ColLen() As Long
'
'    OldMousePointer% = Screen.MousePointer
'    Screen.MousePointer = 11
'
'    ss.ReDraw = False
'    ss.MaxRows = 0
'
'    Call gsubSS_SetMax(ss, ss.MaxRows, ss.MaxCols)
'    If gfunSelectQuery(Query$) Then
'        RetCode% = SQLNumResultCols(ODBChstmt(MainHandle), RetCols%)
'        ReDim ColLen&(RetCols%)
'        For j& = 1 To RetCols%
'            RetCode% = SQLDescribeCol(ODBChstmt(MainHandle), j&, szColName$, cbColNameMax%, pcbColName%, pfSqlType%, pcbColDef&, pibScale%, pfNullable%)
'            ColLen&(j&) = pcbColDef&
'        Next j&
'        ss.ReDraw = False
'        Do While gfunSQLFetch()
'            i& = i& + 1
'            If ss.MaxRows < i& Then ss.MaxRows = i&
'            ss.Row = i&
'            ss.Col = 0: ss.Text = " "
'            For j& = 1 To RetCols%
'                ss.Col = j&
'                ss.Text = gfunODBCGetString$((j&), (ColLen&(j&)))
'            Next j&
'            DoEvents
'            If ss.MaxRows = ss.VisibleRows Then ss.ReDraw = True
'        Loop
'        If ss.MaxRows < ss.VisibleRows Then ss.ReDraw = True
'        Erase ColLen
'    End If
'    RetCode% = SQLFreeStmt(ODBChstmt(MainHandle), SQL_DROP)
'
'    ss.ReDraw = True
'    Screen.MousePointer = OldMousePointer%
'
'End Sub

'-------------------------------------------------------------------
'Spread Sheet���� Ư�� Data�� Position �˻��Ѵ�.(���� Data)
'Arg   TextStr : �˻� Data
'           ss : ��� Sheet
'         Col& : ã�� Spread Sheet Column No
'Return        : Position
'-------------------------------------------------------------------
Public Function gfunSS_Seek(ss As Control, Col&, ByVal TextStr1, Optional Col2&, Optional TextStr2, _
                Optional Col3&, Optional TextStr3, Optional Col4&, Optional TextStr4, Optional Col5&, Optional TextStr5) As Long
'(ss As Control, Col1&, ByVal TextStr1, Optional Col2&, Optional TextStr2, Optional Col3&, Optional TextStr3, Optional Col4&, Optional TextStr4, Optional Col5&, Optional TextStr5)
    Dim i As Long
    
    ss.Col = Col&
    For i& = 1 To ss.DataRowCnt
        ss.Row = i
        If ss.Text = TextStr1 Then
            gfunSS_Seek = i
            Exit Function
        End If
    Next i&
    gfunSS_Seek = 0
   
End Function

'-------------------------------------------------------------------
'Spread Sheet���� Ư�� Data�� Insert Position�� �˻��Ѵ�.(���� Data)
'Arg   TextStr : �˻� Data
'           ss : ��� Sheet
'         Col& : ã�� Spread Sheet Column No
'Return        : Insert Position
'-------------------------------------------------------------------
Public Function gfunSS_SeekNear&(TextStr$, ss As Control, Col&)
    Dim i&
    
    ss.Col = Col&
    For i& = 1 To ss.DataRowCnt
        ss.Row = i&
        If ss.Text >= TextStr$ Then
            gfunSS_SeekNear& = i&
            Exit Function
        End If
    Next i&
    gfunSS_SeekNear& = ss.DataRowCnt + 1
End Function

'-----------------------------------------------------------------------------------
'Spread Sheet���� Ư�� Data�� Insert Position�� �˻��Ѵ�.(Mult Data)
'Arg     ss : Spread Sheet Control
'        Col1&, Col2&, Col3&, Col4&, Col5&                : ã�� Spread Sheet Column
'        TextStr1, TextStr2, TextStr3, TextStr4, TextStr5 : �˻� Data
'Return     : Insert Position
'-----------------------------------------------------------------------------------
Public Function gfunSS_MultSeek_old&(ss As Control, Col1&, ByVal TextStr1, Optional Col2&, Optional TextStr2, Optional Col3&, Optional TextStr3, Optional Col4&, Optional TextStr4, Optional Col5&, Optional TextStr5)

    Dim i&
    
    For i& = 1 To ss.DataRowCnt
        ss.Row = i&
        ss.Col = Col1&
        
        If IIf(IsNumeric(TextStr1), Val(ss.Text), ss.Text) > TextStr1 Or (IIf(IsNumeric(TextStr1), Val(ss.Text), ss.Text) = TextStr1 And Col2& = 0) Then
            gfunSS_MultSeek_old& = i&
            Exit Function
        ElseIf IIf(IsNumeric(TextStr1), Val(ss.Text), ss.Text) = TextStr1 And Col2& > 0 Then
            ss.Col = Col2&
            If IIf(IsNumeric(TextStr2), Val(ss.Text), ss.Text) > TextStr2 Or (IIf(IsNumeric(TextStr2), Val(ss.Text), ss.Text) = TextStr2 And Col3& = 0) Then
                gfunSS_MultSeek_old& = i&
                Exit Function
            ElseIf IIf(IsNumeric(TextStr2), Val(ss.Text), ss.Text) = TextStr2 And Col3& > 0 Then
                ss.Col = Col3&
                If IIf(IsNumeric(TextStr3), Val(ss.Text), ss.Text) > TextStr3 Or (IIf(IsNumeric(TextStr3), Val(ss.Text), ss.Text) = TextStr3 And Col4& = 0) Then
                    gfunSS_MultSeek_old& = i&
                    Exit Function
                ElseIf IIf(IsNumeric(TextStr3), Val(ss.Text), ss.Text) = TextStr3 And Col4& > 0 Then
                    ss.Col = Col4&
                    If IIf(IsNumeric(TextStr4), Val(ss.Text), ss.Text) > TextStr4 Or (IIf(IsNumeric(TextStr4), Val(ss.Text), ss.Text) = TextStr4 And Col5& = 0) Then
                        gfunSS_MultSeek_old& = i&
                        Exit Function
                    ElseIf IIf(IsNumeric(TextStr4), Trim(Str(Val(ss.Text))), ss.Text) = TextStr4 And Col5& > 0 Then
                        If IIf(IsNumeric(TextStr5), Val(ss.Text), ss.Text) >= TextStr5 Then
                            gfunSS_MultSeek_old& = i&
                            Exit Function
                        End If
                    End If
                End If
            End If
        End If
    Next i&
    gfunSS_MultSeek_old& = ss.DataRowCnt + 1

End Function

Public Function gfunSS_MultSeek&(ss As Control, Col1&, ByVal TextStr1, Optional Col2&, Optional TextStr2, Optional Col3&, Optional TextStr3, Optional Col4&, Optional TextStr4, Optional Col5&, Optional TextStr5)

    Dim i   As Long
    
    For i = 1 To ss.DataRowCnt
        ss.Row = i
        ss.Col = Col1
        If ss.CellType = 2 Or ss.CellType = 3 Then
            If Val(ss.Text) > Val(TextStr1) Or (Val(ss.Text) = Val(TextStr1) And Col2 = 0) Then
                gfunSS_MultSeek = i
                Exit Function
            ElseIf Val(ss.Text) = Val(TextStr1) And Col2 > 0 Then
                ss.Col = Col2
                If Val(ss.Text) > Val(TextStr2) Or (Val(ss.Text) = Val(TextStr2) And Col3 = 0) Then
                    gfunSS_MultSeek = i
                    Exit Function
                ElseIf Val(ss.Text) = Val(TextStr2) And Col3 > 0 Then
                    ss.Col = Col3
                    If Val(ss.Text) > Val(TextStr3) Or (Val(ss.Text) = Val(TextStr3) And Col4 = 0) Then
                        gfunSS_MultSeek = i
                        Exit Function
                    ElseIf Val(ss.Text) = Val(TextStr3) And Col4 > 0 Then
                        ss.Col = Col4
                        If Val(ss.Text) > Val(TextStr3) Or (Val(ss.Text) = Val(TextStr3) And Col5 = 0) Then
                            gfunSS_MultSeek& = i
                            Exit Function
                        ElseIf Val(ss.Text) = Val(TextStr4) And Col5 > 0 Then
                            If Val(ss.Text) >= Val(TextStr5) Then
                                gfunSS_MultSeek& = i&
                                Exit Function
                            End If
                        End If
                    End If
                End If
            End If
        
        Else
            If ss.Text > TextStr1 Or (ss.Text = TextStr1 And Col2 = 0) Then
                gfunSS_MultSeek = i
                Exit Function
            ElseIf ss.Text = TextStr1 And Col2 > 0 Then
                ss.Col = Col2
                If ss.Text > TextStr2 Or (ss.Text = TextStr2 And Col3 = 0) Then
                    gfunSS_MultSeek = i
                    Exit Function
                ElseIf ss.Text = TextStr2 And Col3 > 0 Then
                    ss.Col = Col3
                    If ss.Text > TextStr3 Or (ss.Text = TextStr3 And Col4 = 0) Then
                        gfunSS_MultSeek = i
                        Exit Function
                    ElseIf ss.Text = TextStr3 And Col4 > 0 Then
                        ss.Col = Col4
                        If ss.Text > TextStr3 Or (ss.Text = TextStr3 And Col5 = 0) Then
                            gfunSS_MultSeek& = i
                            Exit Function
                        ElseIf ss.Text = TextStr4 And Col5 > 0 Then
                            If ss.Text >= TextStr5 Then
                                gfunSS_MultSeek& = i&
                                Exit Function
                            End If
                        End If
                    End If
                End If
            End If
        End If
        
        
    Next
    gfunSS_MultSeek& = ss.DataRowCnt + 1

End Function

