﻿unit TelegAPI.Bot.Console;

interface

uses
  TelegAPI.Bot,
  System.Classes,
  TelegAPI.Types,
  System.SysUtils,
  TelegAPI.Exceptions;

type
  TTelegramBotConsole = class(TelegAPI.Bot.TTelegramBot)
    type
      TtgRecesiver = class(TThread)
      private
        FBot: TTelegramBotConsole;
      protected
        procedure Execute; override;
        /// <summary>
        ///   Raises the <see cref="TelegAPI.Bot|TtgOnUpdate" />, <see cref="TelegAPI.Bot|TtgOnMessage" />
        ///    , <see cref="TelegAPI.Bot|TtgOnInlineQuery" /> , <see cref="TelegAPI.Bot|TtgOnInlineResultChosen" />
        ///    and <see cref="TelegAPI.Bot|TtgOnCallbackQuery" /> events.
        /// </summary>
        /// <param name="AValue">
        ///   The <see cref="TelegAPi.Types|TtgUpdate">Update</see> instance
        ///   containing the event data. <br />
        /// </param>
        /// <exception cref="TelegaPi.Exceptions|ETelegramException">
        ///   Возникает если получено неизвестное обновление
        /// </exception>
        procedure OnUpdateReceived(AValue: TtgUpdate);
      public
        property Bot: TTelegramBotConsole read FBot write FBot;
      end;
  private
    FOnUpdate: TProc<TtgUpdate>;
    FRecesiver: TtgRecesiver;
    FIsReceiving: Boolean;
    FOnDisconnect: TProc;
    FOnMessage: TProc<TtgMessage>;
    FOnMessageEdited: TProc<TtgMessage>;
    FOnChannelPost: TProc<TtgMessage>;
    FOnInlineQuery: TProc<TtgInlineQuery>;
    FOnInlineResultChosen: TProc<TtgChosenInlineResult>;
    FOnReceiveError: TProc<EApiRequestException>;
    FOnCallbackQuery: TProc<TtgCallbackQuery>;
    FOnConnect: TProc;
    FOnReceiveGeneralError: TProc<Exception>;
    FOnRawData: TProc<string>;
  protected
    procedure SetIsReceiving(const Value: Boolean);
    procedure DoDisconnect(ASender: TObject);
  public
    constructor Create(const AToken: string);
    /// <summary>
    ///   <para>
    ///     Indicates if receiving updates
    ///   </para>
    ///   <para>
    ///     Асинхронный прием обновлений от сервера
    ///   </para>
    /// </summary>
    property IsReceiving: Boolean read FIsReceiving write SetIsReceiving default False;
  published
{$REGION 'События|Events'}
    /// <summary>
    ///   <para>
    ///     Событие возникает когда получено <see cref="TelegAPi.Types|TtgUpdate" />
    ///   </para>
    ///   <para>
    ///     Occurs when an <see cref="TelegAPi.Types|TtgUpdate" /> is
    ///     received.
    ///   </para>
    /// </summary>
    property OnUpdate: TProc<TtgUpdate> read FOnUpdate write FOnUpdate;
    /// <summary>
    ///   <para>
    ///     Событие возникает когда получено <see cref="TelegAPi.Types|TtgMessage" />
    ///   </para>
    ///   <para>
    ///     Occurs when a <see cref="TelegAPi.Types|TtgMessage" /> is
    ///     recieved.
    ///   </para>
    /// </summary>
    property OnMessage: TProc<TtgMessage> read FOnMessage write FOnMessage;
    /// <summary>
    ///   <para>
    ///     Возникает когда <see cref="TelegAPi.Types|TtgMessage" /> было
    ///     изменено.
    ///   </para>
    ///   <para>
    ///     Occurs when <see cref="TelegAPi.Types|TtgMessage" /> was edited.
    ///   </para>
    /// </summary>
    property OnMessageEdited: TProc<TtgMessage> read FOnMessageEdited write FOnMessageEdited;
    property OnChannelPost: TProc<TtgMessage> read FOnChannelPost write FOnChannelPost;
    /// <summary>
    ///   <para>
    ///     Возникает, когда получен <see cref="TelegAPi.Types|TtgInlineQuery" />
    ///   </para>
    ///   <para>
    ///     Occurs when an <see cref="TelegAPi.Types|TtgInlineQuery" /> is
    ///     received.
    ///   </para>
    /// </summary>
    property OnInlineQuery: TProc<TtgInlineQuery> read FOnInlineQuery write FOnInlineQuery;
    /// <summary>
    ///   <para>
    ///     Возникает когда получен <see cref="TelegAPi.Types|TtgChosenInlineResult" />
    ///   </para>
    ///   <para>
    ///     Occurs when a <see cref="TelegAPi.Types|TtgChosenInlineResult" />
    ///     is received.
    ///   </para>
    /// </summary>
    property OnInlineResultChosen: TProc<TtgChosenInlineResult> read FOnInlineResultChosen write FOnInlineResultChosen;
    /// <summary>
    ///   <para>
    ///     Возникает когда получен <see cref="TelegAPi.Types|TtgCallbackQuery" />
    ///   </para>
    ///   <para>
    ///     Occurs when an <see cref="TelegAPi.Types|TtgCallbackQuery" /> is
    ///     received
    ///   </para>
    /// </summary>
    property OnCallbackQuery: TProc<TtgCallbackQuery> read FOnCallbackQuery write FOnCallbackQuery;
    /// <summary>
    ///   <para>
    ///     Возникает при возникновении ошибки во время запроса фоновых
    ///     обновлений.
    ///   </para>
    ///   <para>
    ///     Occurs when an error occures during the background update
    ///     pooling.
    ///   </para>
    /// </summary>
    property OnReceiveError: TProc<EApiRequestException> read FOnReceiveError write FOnReceiveError;
    /// <summary>
    ///   <para>
    ///     Возникает при возникновении ошибки во время запроса фоновых
    ///     обновлений.
    ///   </para>
    ///   <para>
    ///     Occurs when an error occures during the background update
    ///     pooling.
    ///   </para>
    /// </summary>
    property OnReceiveGeneralError: TProc<Exception> read FOnReceiveGeneralError write FOnReceiveGeneralError;
    property OnConnect: TProc read FOnConnect write FOnConnect;
    property OnDisconnect: TProc read FOnDisconnect write FOnDisconnect;
    property OnReceiveRawData: TProc<string> read FOnRawData write FOnRawData;
{$ENDREGION}
  end;

implementation

uses
  TelegAPI.Types.Enums;

{ TTelegramBotConsole.TtgRecesiver }

procedure TTelegramBotConsole.TtgRecesiver.Execute;
var
  LUpdates: TArray<TtgUpdate>;
  I: Integer;
begin
  if Assigned(Bot.OnConnect) then
    Bot.OnConnect();
  repeat
    LUpdates := FBot.GetUpdates(Bot.MessageOffset, 100, 0, Bot.AllowedUpdates);
    if Length(LUpdates) > 0 then
    begin
      Bot.MessageOffset := LUpdates[High(LUpdates)].ID + 1;
      for I := Low(LUpdates) to High(LUpdates) do
        Self.OnUpdateReceived(LUpdates[I]);
      if Assigned(LUpdates) then
      begin
        for I := Low(LUpdates) to High(LUpdates) do
          FreeAndNil(LUpdates[I]);
        LUpdates := nil;
      end;
    end;
    Sleep(Bot.PollingTimeout);
  until (Terminated) or (not Bot.IsReceiving);
end;

procedure TTelegramBotConsole.TtgRecesiver.OnUpdateReceived(AValue: TtgUpdate);
begin
  if Assigned(Bot.OnUpdate) then
    Bot.OnUpdate(AValue);
  case AValue.&Type of
    TtgUpdateType.MessageUpdate:
      if Assigned(Bot.OnMessage) then
        Bot.OnMessage(AValue.Message);
    TtgUpdateType.InlineQueryUpdate:
      if Assigned(Bot.OnInlineQuery) then
        Bot.OnInlineQuery(AValue.InlineQuery);
    TtgUpdateType.ChosenInlineResultUpdate:
      if Assigned(Bot.OnInlineResultChosen) then
        Bot.OnInlineResultChosen(AValue.ChosenInlineResult);
    TtgUpdateType.CallbackQueryUpdate:
      if Assigned(Bot.OnCallbackQuery) then
        Bot.OnCallbackQuery(AValue.CallbackQuery);
    TtgUpdateType.EditedMessage:
      if Assigned(Bot.OnMessageEdited) then
        Bot.OnMessageEdited(AValue.EditedMessage);
    TtgUpdateType.ChannelPost:
      if Assigned(Bot.OnChannelPost) then
        Bot.OnChannelPost(AValue.ChannelPost);
  else
    raise ETelegramException.Create('Unknown update type');
  end
end;

{ TTelegramBotConsole }

constructor TTelegramBotConsole.Create(const AToken: string);
begin
  inherited Create(nil);
  Token := AToken;
end;

procedure TTelegramBotConsole.DoDisconnect(ASender: TObject);
begin
  if Assigned(OnDisconnect) then
    OnDisconnect;
end;

procedure TTelegramBotConsole.SetIsReceiving(const Value: Boolean);
begin
  // duplicate FReceiver creation and freeing protection
  if FIsReceiving=Value then exit;

  FIsReceiving := Value;
  if Value then
  begin
    FRecesiver := TtgRecesiver.Create(True);
    FRecesiver.FreeOnTerminate := False;
    FRecesiver.Bot := TTelegramBotConsole(Self);
    FRecesiver.OnTerminate := DoDisconnect;
    FRecesiver.Start;
  end
  else
  begin
    FreeAndNil(FRecesiver);
  end;
end;



end.

