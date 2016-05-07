﻿unit TelegAPI.Bot;

{$I ../jedi/jedi.inc}
{$IFNDEF DELPHIXE7_UP}
Поддерживается только RAD Studio XE7 и выше !
{$ENDIF}
  interface

  uses System.Generics.Collections, System.Rtti, System.Threading, TelegAPI.Types, System.Classes;

Type
  TTelegaBotOnUpdate = procedure(Const Sender: TObject; Const Update: TTelegaUpdate) of Object;
  TTelegaBorOnError = procedure(Const Sender: TObject; Const Code: Integer; Const Message: String)
    of Object;

  TTelegramBot = Class(TComponent)
  private
    FToken: String;
    FOnUpdate: TTelegaBotOnUpdate;
    FIsReceiving: Boolean;
    FUploadTimeout: Integer;
    FPollingTimeout: Integer;
    FMessageOffset: Integer;
    FOnError: TTelegaBorOnError;
    FUpdatePool: TList<TTelegaBotOnUpdate>;

    function IfThen(Value: Boolean; IfTrue: String; IfFalse: String): String;
    procedure SetIsReceiving(const Value: Boolean);
  protected
    /// <summary>Мастер-функция для запросов на сервак</summary>
    Function API<T>(Const Method: String; Const Parameters: TDictionary<String, TValue>): T;
  public

    /// <summary>A simple method for testing your bot's auth token.</summary>
    /// <returns>Returns basic information about the bot in form of a User object.</returns>
    Function getMe: TTelegaUser;
    /// <summary>Use this method to receive incoming updates using long polling. An Array of Update objects is returned.</summary>
    /// <param name="offset">Identifier of the first update to be returned. Must be greater by one than the highest among the identifiers of previously received updates. By default, updates starting with the earliest unconfirmed update are returned. An update is considered confirmed as soon as getUpdates is called with an offset higher than its update_id. The negative offset can be specified to retrieve updates starting from -offset update from the end of the updates queue. All previous updates will forgotten. </param>
    /// <param name="limit">Limits the number of updates to be retrieved. Values between 1—100 are accepted. Defaults to 100. </param>
    /// <param name="timeout">Timeout in seconds for long polling. Defaults to 0, i.e. usual short polling</param>
    Function getUpdates(Const offset: Integer = 0; Const limit: Integer = 100;
      Const timeout: Integer = 0): TArray<TTelegaUpdate>;
    /// <summary>Use this method to send text messages.</summary>
    /// <param name="chat_id">Integer or String. Unique identifier for the target chat or username of the target channel (in the format @channelusername).</param>
    /// <param name="text">Text of the message to be sent</param>
    /// <param name="parse_mode">Send Markdown or HTML, if you want Telegram apps to show bold, italic, fixed-width text or inline URLs in your bot's message.</param>
    /// <param name="disable_web_page_preview">Disables link previews for links in this message</param>
    /// <param name="disable_notification">Sends the message silently. iOS users will not receive a notification, Android users will receive a notification with no sound.</param>
    /// <param name="reply_to_message_id">If the message is a reply, ID of the original message</param>
    /// <param name="reply_markup">InlineKeyboardMarkup or ReplyKeyboardMarkup or ReplyKeyboardHide or ForceReply. Additional interface options. A JSON-serialized object for an inline keyboard, custom reply keyboard, instructions to hide reply keyboard or to force a reply from the user.</param>
    /// <returns>On success, the sent Message is returned.</returns>
    Function sendTextMessage(Const chat_id: TValue; text: String;
      ParseMode: TTelegaParseMode = TTelegaParseMode.Default;
      disableWebPagePreview: Boolean = False; disable_notification: Boolean = False;
      replyToMessageId: Integer = 0; replyMarkup: TTelegaReplyKeyboardMarkup = nil): TTelegaMessage;
    Function forwardMessage(chat_id: TValue; from_chat_id: TValue;
      disable_notification: Boolean = False; message_id: Integer = 0): TTelegaMessage;
    Function sendPhoto(chatId: TValue; photo: TValue; caption: string = '';
      disable_notification: Boolean = False; replyToMessageId: Integer = 0;
      replyMarkup: TTelegaReplyKeyboardMarkup = nil): TTelegaMessage;
    Function sendAudio(chat_id: TValue; audio: TValue; duration: Integer = 0;
      performer: String = ''; title: String = ''; disable_notification: Boolean = False;
      reply_to_message_id: Integer = 0; replyMarkup: TTelegaReplyKeyboardMarkup = nil)
      : TTelegaMessage;
    Function sendDocument(chat_id: TValue; document: TValue; caption: String = '';
      disable_notification: Boolean = False; reply_to_message_id: Integer = 0;
      reply_markup: TTelegaReplyKeyboardMarkup = nil): TTelegaMessage;
    Function sendSticker(chat_id: TValue; sticker: TValue; caption: String = '';
      disable_notification: Boolean = False; reply_to_message_id: Integer = 0;
      reply_markup: TTelegaReplyKeyboardMarkup = nil): TTelegaMessage;
    function sendVideo(chat_id: TValue; video: TValue; duration: Integer = 0; width: Integer = 0;
      height: Integer = 0; caption: String = ''; disable_notification: Boolean = False;
      reply_to_message_id: Integer = 0; reply_markup: TTelegaReplyKeyboardMarkup = nil)
      : TTelegaMessage;
    Function sendVoice(chat_id: TValue; voice: TValue; duration: Integer = 0;
      disable_notification: Boolean = False; reply_to_message_id: Integer = 0;
      reply_markup: TTelegaReplyKeyboardMarkup = nil): TTelegaMessage;

    Function sendLocation(chat_id: TValue; Location: TTelegaLocation;
      disable_notification: Boolean = False; reply_to_message_id: Integer = 0;
      reply_markup: TTelegaReplyKeyboardMarkup = nil): TTelegaMessage;

    Function sendVenue(chat_id: TValue; venue: TTelegaVenue; disable_notification: Boolean = False;
      reply_to_message_id: Integer = 0; reply_markup: TTelegaReplyKeyboardMarkup = nil)
      : TTelegaMessage;
    Function sendContact(chat_id: TValue; contact: TTelegaContact;
      disable_notification: Boolean = False; reply_to_message_id: Integer = 0;
      reply_markup: TTelegaReplyKeyboardMarkup = nil): TTelegaMessage;

    Procedure sendChatAction(chat_id: TValue; action: String);
    Function getUserProfilePhotos(chat_id: TValue; offset: Integer; limit: Integer = 100)
      : TTelegaUserProfilePhotos;

    Function getFile(file_id: String): TTelegaFile;
    Function kickChatMember(chat_id: TValue; user_id: Integer): Boolean;
    Function unbanChatMember(chat_id: TValue; user_id: Integer): Boolean;
    Function answerCallbackQuery(callback_query_id: String; text: String = '';
      show_alert: Boolean = False): Boolean;

    Function editMessageText(chat_id: TValue; message_id: Integer; inline_message_id: String;
      text: String; parse_mode: TTelegaParseMode = TTelegaParseMode.Default;
      disable_web_page_preview: Boolean = False;
      reply_markup: TTelegaReplyKeyboardMarkup = nil): Boolean;
    Function editMessageCaption(chat_id: TValue; message_id: Integer; inline_message_id: String;
      caption: String; reply_markup: TTelegaReplyKeyboardMarkup = nil): Boolean;
    Function editMessageReplyMarkup(chat_id: TValue; message_id: Integer; inline_message_id: String;
      reply_markup: TTelegaReplyKeyboardMarkup = nil): Boolean;
    /// <summary>Use this method to send answers to an inline query.</summary>
    /// <returns>On success, True is returned.</returns>
    /// <remarks>No more than 50 results per query are allowed.</remarks>
    /// <param name="inline_query_id">Unique identifier for the answered query</param>
    /// <param name="results">A JSON-serialized array of results for the inline query</param>
    /// <param name="cache_time">The maximum amount of time in seconds that the result of the inline query may be cached on the server. Defaults to 300.</param>
    /// <param name="is_personal">Pass True, if results may be cached on the server side only for the user that sent the query. By default, results may be returned to any user who sends the same query</param>
    /// <param name="next_offset">Pass the offset that a client should send in the next query with the same text to receive more results. Pass an empty string if there are no more results or if you don‘t support pagination. Offset length can’t exceed 64 bytes.</param>
    /// <param name="switch_pm_text">If passed, clients will display a button with specified text that switches the user to a private chat with the bot and sends the bot a start message with the parameter switch_pm_parameter</param>
    /// <param name="switch_pm_parameter">Parameter for the start message sent to the bot when user presses the switch button</param>
    Function answerInlineQuery(inline_query_id: String; results: TArray<TTelegaInlineQueryResult>;
      cache_time: Integer = 300; is_personal: Boolean = False; next_offset: String = '';
      switch_pm_text: String = ''; switch_pm_parameter: String = ''): Boolean;

    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(Const Token: String); overload;
    destructor Destroy; override;
  published
    { x } property UploadTimeout: Integer read FUploadTimeout write FUploadTimeout default 60000;
    { x } property PollingTimeout: Integer read FPollingTimeout write FPollingTimeout default 1000;
    property MessageOffset: Integer read FMessageOffset write FMessageOffset default 0;
    /// <summary>Монитор слежки за обновлениями</summary>
    property IsReceiving: Boolean read FIsReceiving write SetIsReceiving default False;
    property Token: String read FToken write FToken;
    property UpdatePool: TList<TTelegaBotOnUpdate> read FUpdatePool write FUpdatePool;
    property OnUpdate: TTelegaBotOnUpdate read FOnUpdate write FOnUpdate;
    property OnError: TTelegaBorOnError read FOnError write FOnError;
  End;

implementation

uses
  XSuperObject,
  System.SysUtils,
  System.Net.Mime,

  System.Net.HttpClient, System.TypInfo;

Function ToModeString(Mode: TTelegaParseMode): String;
Begin
  case Mode of
    TTelegaParseMode.Default:
      Result := '';
    TTelegaParseMode.Markdown:
      Result := 'Markdown';
    TTelegaParseMode.Html:
      Result := 'HTML';
  end;
End;

{ TTelegram }
function TTelegramBot.answerCallbackQuery(callback_query_id, text: String;
  show_alert: Boolean): Boolean;
var
  Parameters: TDictionary<String, TValue>;
begin
  Parameters := TDictionary<String, TValue>.Create;
  try
    Parameters.Add('callback_query_id', callback_query_id);
    Parameters.Add('text', text);
    Parameters.Add('show_alert', show_alert);
    Result := API<Boolean>('forwardMessage', Parameters);
  finally
    Parameters.Free;
  end;
end;

function TTelegramBot.answerInlineQuery(inline_query_id: String;
  results: TArray<TTelegaInlineQueryResult>; cache_time: Integer; is_personal: Boolean;
  next_offset, switch_pm_text, switch_pm_parameter: String): Boolean;
var
  Parameters: TDictionary<String, TValue>;
  TestArr: Array of TValue;
  I: Integer;
begin
  Parameters := TDictionary<String, TValue>.Create;
  try
    Parameters.Add('inline_query_id', inline_query_id);
    SetLength(TestArr, Length(results));
    for I := Low(results) to High(results) do
      TestArr[I] := results[I];
    Parameters.Add('results', TValue.FromArray(PTypeInfo(TestArr), TestArr));
    Parameters.Add('cache_time', cache_time);
    Parameters.Add('is_personal', is_personal);
    Parameters.Add('next_offset', next_offset);
    Parameters.Add('switch_pm_text', switch_pm_text);
    Parameters.Add('switch_pm_parameter', switch_pm_parameter);
    Result := API<Boolean>('answerInlineQuery', Parameters);
  finally
    Parameters.Free;
  end;
end;

function TTelegramBot.API<T>(const Method: String;
  Const Parameters: TDictionary<String, TValue>): T;
var
  Http: THTTPClient;
  content: String;
  Response: TTelegaApiResponse<T>;
  parameter: TPair<String, TValue>;
  Form: TMultipartFormData;
begin
  Http := THTTPClient.Create;
  Form := TMultipartFormData.Create;
  try
    // Преобразовуем параметры в строку, если нужно
    if Assigned(Parameters) then
    Begin
      for parameter in Parameters do
      begin
        if parameter.Value.IsType<TTelegaReplyKeyboardMarkup> then
        begin
          { TODO -oOwner -cGeneral : Проверить че за херня тут твориться }
          if parameter.Value.AsType<TTelegaReplyKeyboardMarkup> <> nil then

            Form.AddField(parameter.Key, parameter.Value.AsType<TTelegaReplyKeyboardMarkup>.AsJSON);
        end
        else if parameter.Value.IsType<TTelegaFileToSend> then
        Begin
          { TODO -oOwner -cGeneral : Отправка файлов }
          Form.AddFile(parameter.Key, parameter.Value.AsType<TTelegaFileToSend>.FileName);
        End
        else
        begin
          if parameter.Value.IsType<string> then
          Begin
            if NOT parameter.Value.AsString.IsEmpty then
              Form.AddField(parameter.Key, parameter.Value.AsString)
          End
          else if parameter.Value.IsType<Int64> then
          Begin
            if parameter.Value.AsInt64 <> 0 then
              Form.AddField(parameter.Key, IntToStr(parameter.Value.AsInt64));
          End
          else if parameter.Value.IsType<Boolean> then
          Begin
            if parameter.Value.AsBoolean = True then
              Form.AddField(parameter.Key, IfThen(parameter.Value.AsBoolean, 'true', 'false'))
          End;
        end;
      end;
    End;

    content := Http.Post('https://api.telegram.org/bot' + FToken + '/' + Method, Form)
      .ContentAsString(TEncoding.UTF8);
    if Pos('502 Bad Gateway', content) > 0 then
    begin
      if Assigned(OnError) then
        OnError(Self, 502, 'Bad Gateway');
      Exit;
    end;
    Response := TTelegaApiResponse<T>.FromJSON(content);
    if Not Response.Ok then
    begin
      if Assigned(OnError) then
        OnError(Self, Response.Code, Response.Message);
      Exit;
    end;
    Result := Response.ResultObject;
  finally
    Http.Free;
  end;
end;

constructor TTelegramBot.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Create('');
end;

constructor TTelegramBot.Create(const Token: String);
begin
  FUpdatePool := TList<TTelegaBotOnUpdate>.Create;
  FToken := Token;
  IsReceiving := False;
  UploadTimeout := 60000;
  PollingTimeout := 1000;
  MessageOffset := 0;
end;

destructor TTelegramBot.Destroy;
begin
  FUpdatePool.Free;
  inherited;
end;

function TTelegramBot.editMessageCaption(chat_id: TValue; message_id: Integer;
  inline_message_id, caption: String; reply_markup: TTelegaReplyKeyboardMarkup): Boolean;
var
  Parameters: TDictionary<String, TValue>;
begin
  Parameters := TDictionary<String, TValue>.Create;
  try
    Parameters.Add('chat_id', chat_id);
    Parameters.Add('message_id', message_id);
    Parameters.Add('inline_message_id', inline_message_id);
    Parameters.Add('caption', caption);
    Parameters.Add('reply_markup', reply_markup);
    Result := API<Boolean>('editMessageCaption', Parameters);
  finally
    Parameters.Free;
  end;
end;

function TTelegramBot.editMessageReplyMarkup(chat_id: TValue; message_id: Integer;
  inline_message_id: String; reply_markup: TTelegaReplyKeyboardMarkup): Boolean;
var
  Parameters: TDictionary<String, TValue>;
begin
  Parameters := TDictionary<String, TValue>.Create;
  try
    Parameters.Add('chat_id', chat_id);
    Parameters.Add('message_id', message_id);
    Parameters.Add('inline_message_id', inline_message_id);
    Parameters.Add('reply_markup', reply_markup);
    Result := API<Boolean>('editMessageText', Parameters);
  finally
    Parameters.Free;
  end;
end;

function TTelegramBot.editMessageText(chat_id: TValue; message_id: Integer;
  inline_message_id, text: String; parse_mode: TTelegaParseMode; disable_web_page_preview: Boolean;
  reply_markup: TTelegaReplyKeyboardMarkup): Boolean;
var
  Parameters: TDictionary<String, TValue>;
begin
  Parameters := TDictionary<String, TValue>.Create;
  try
    Parameters.Add('chat_id', chat_id);
    Parameters.Add('message_id', message_id);
    Parameters.Add('inline_message_id', inline_message_id);
    Parameters.Add('text', text);
    Parameters.Add('parse_mode', ToModeString(parse_mode));
    Parameters.Add('disable_web_page_preview', disable_web_page_preview);
    Parameters.Add('reply_markup', reply_markup);
    Result := API<Boolean>('editMessageText', Parameters);
  finally
    Parameters.Free;
  end;
end;

function TTelegramBot.forwardMessage(chat_id, from_chat_id: TValue; disable_notification: Boolean;
  message_id: Integer): TTelegaMessage;
var
  Parameters: TDictionary<String, TValue>;
begin
  Parameters := TDictionary<String, TValue>.Create;
  try
    Parameters.Add('chat_id', chat_id);
    Parameters.Add('from_chat_id', from_chat_id);
    Parameters.Add('disable_notification', disable_notification);
    Parameters.Add('message_id', message_id);
    Result := API<TTelegaMessage>('forwardMessage', Parameters);
  finally
    Parameters.Free;
  end;
end;

function TTelegramBot.getFile(file_id: String): TTelegaFile;
var
  Parameters: TDictionary<String, TValue>;
begin
  Parameters := TDictionary<String, TValue>.Create;
  try
    Parameters.Add('file_id', file_id);
    Result := Self.API<TTelegaFile>('getFile', Parameters);
  finally
    Parameters.Free;
  end;
end;

function TTelegramBot.getMe: TTelegaUser;
begin
  Result := Self.API<TTelegaUser>('getMe', nil);
end;

function TTelegramBot.getUpdates(const offset, limit, timeout: Integer): TArray<TTelegaUpdate>;
var
  Parameters: TDictionary<String, TValue>;
begin
  Parameters := TDictionary<String, TValue>.Create;
  try
    Parameters.Add('offset', offset);
    Parameters.Add('limit', limit);
    Parameters.Add('timeout', timeout);
    Result := Self.API < TArray < TTelegaUpdate >> ('getUpdates', Parameters);
  finally
    Parameters.Free;
  end;
end;

function TTelegramBot.getUserProfilePhotos(chat_id: TValue; offset, limit: Integer)
  : TTelegaUserProfilePhotos;
var
  Parameters: TDictionary<String, TValue>;
begin
  Parameters := TDictionary<String, TValue>.Create;
  try
    Parameters.Add('chat_id', chat_id);
    Parameters.Add('offset', offset);
    Parameters.Add('limit', limit);
    Result := API<TTelegaUserProfilePhotos>('getUserProfilePhotos', Parameters);
  finally
    Parameters.Free;
  end;
end;

function TTelegramBot.IfThen(Value: Boolean; IfTrue, IfFalse: String): String;
begin
  if Value then
    Result := IfTrue
  else
    Result := IfFalse;
end;

function TTelegramBot.kickChatMember(chat_id: TValue; user_id: Integer): Boolean;
var
  Parameters: TDictionary<String, TValue>;
begin
  Parameters := TDictionary<String, TValue>.Create;
  try
    Parameters.Add('chat_id', chat_id);
    Parameters.Add('user_id', user_id);
    Result := API<Boolean>('kickChatMember', Parameters);
  finally
    Parameters.Free;
  end;
end;

function TTelegramBot.sendAudio(chat_id, audio: TValue; duration: Integer; performer, title: String;
  disable_notification: Boolean; reply_to_message_id: Integer;
  replyMarkup: TTelegaReplyKeyboardMarkup): TTelegaMessage;
var
  Parameters: TDictionary<String, TValue>;
begin
  Parameters := TDictionary<String, TValue>.Create;
  try
    Parameters.Add('chat_id', chat_id);
    Parameters.Add('audio', audio);
    Parameters.Add('duration', duration);
    Parameters.Add('performer', performer);
    Parameters.Add('title', title);
    Parameters.Add('disable_notification', disable_notification);
    Parameters.Add('reply_to_message_id', reply_to_message_id);
    Parameters.Add('reply_markup', replyMarkup);
    Result := API<TTelegaMessage>('sendAudio', Parameters);
  finally
    Parameters.Free;
  end;
end;

procedure TTelegramBot.sendChatAction(chat_id: TValue; action: String);
var
  Parameters: TDictionary<String, TValue>;
begin
  Parameters := TDictionary<String, TValue>.Create;
  try
    Parameters.Add('chat_id', chat_id);
    Parameters.Add('action', action);
    API<Boolean>('sendChatAction', Parameters);
  finally
    Parameters.Free;
  end;
end;

function TTelegramBot.sendContact(chat_id: TValue; contact: TTelegaContact;
  disable_notification: Boolean; reply_to_message_id: Integer;
  reply_markup: TTelegaReplyKeyboardMarkup): TTelegaMessage;
var
  Parameters: TDictionary<String, TValue>;
begin
  Parameters := TDictionary<String, TValue>.Create;
  try
    Parameters.Add('chat_id', chat_id);
    Parameters.Add('phone_number', contact.PhoneNumber);
    Parameters.Add('first_name', contact.FirstName);
    Parameters.Add('last_name', contact.LastName);
    Parameters.Add('disable_notification', disable_notification);
    Parameters.Add('reply_to_message_id', reply_to_message_id);
    Parameters.Add('reply_markup', reply_markup);
    Result := API<TTelegaMessage>('sendContact', Parameters);
  finally
    Parameters.Free;
  end;
end;

function TTelegramBot.sendDocument(chat_id, document: TValue; caption: String;
  disable_notification: Boolean; reply_to_message_id: Integer;
  reply_markup: TTelegaReplyKeyboardMarkup): TTelegaMessage;
var
  Parameters: TDictionary<String, TValue>;
begin
  Parameters := TDictionary<String, TValue>.Create;
  try
    Parameters.Add('chat_id', chat_id);
    Parameters.Add('document', document);
    Parameters.Add('caption', caption);
    Parameters.Add('disable_notification', disable_notification);
    Parameters.Add('reply_to_message_id', reply_to_message_id);
    Parameters.Add('reply_markup', reply_markup);
    Result := API<TTelegaMessage>('sendDocument', Parameters);
  finally
    Parameters.Free;
  end;
end;

function TTelegramBot.sendLocation(chat_id: TValue; Location: TTelegaLocation;
  disable_notification: Boolean; reply_to_message_id: Integer;
  reply_markup: TTelegaReplyKeyboardMarkup): TTelegaMessage;
var
  Parameters: TDictionary<String, TValue>;
begin
  Parameters := TDictionary<String, TValue>.Create;
  try
    Parameters.Add('chat_id', chat_id);
    Parameters.Add('latitude', Location.Latitude);
    Parameters.Add('longitude', Location.Longitude);
    Parameters.Add('disable_notification', disable_notification);
    Parameters.Add('reply_to_message_id', reply_to_message_id);
    Parameters.Add('reply_markup', reply_markup);
    Result := API<TTelegaMessage>('sendLocation', Parameters);
  finally
    Parameters.Free;
  end;
end;

function TTelegramBot.sendPhoto(chatId, photo: TValue; caption: string;
  disable_notification: Boolean; replyToMessageId: Integer; replyMarkup: TTelegaReplyKeyboardMarkup)
  : TTelegaMessage;
var
  Parameters: TDictionary<String, TValue>;
begin
  Parameters := TDictionary<String, TValue>.Create;
  try
    Parameters.Add('chat_id', chatId);
    Parameters.Add('photo', photo);
    Parameters.Add('caption', caption);
    Parameters.Add('disable_notification', disable_notification);
    Parameters.Add('reply_to_message_id', replyToMessageId);
    Parameters.Add('reply_markup', replyMarkup);
    Result := API<TTelegaMessage>('sendPhoto', Parameters);
  finally
    Parameters.Free;
  end;
end;

function TTelegramBot.sendSticker(chat_id, sticker: TValue; caption: String;
  disable_notification: Boolean; reply_to_message_id: Integer;
  reply_markup: TTelegaReplyKeyboardMarkup): TTelegaMessage;
var
  Parameters: TDictionary<String, TValue>;
begin
  Parameters := TDictionary<String, TValue>.Create;
  try
    Parameters.Add('chat_id', chat_id);
    Parameters.Add('sticker', sticker);
    Parameters.Add('caption', caption);
    Parameters.Add('disable_notification', disable_notification);
    Parameters.Add('reply_to_message_id', reply_to_message_id);
    Parameters.Add('reply_markup', reply_markup);
    Result := API<TTelegaMessage>('sendSticker', Parameters);
  finally
    Parameters.Free;
  end;
end;

function TTelegramBot.sendTextMessage(const chat_id: TValue; text: String;
  ParseMode: TTelegaParseMode; disableWebPagePreview, disable_notification: Boolean;
  replyToMessageId: Integer; replyMarkup: TTelegaReplyKeyboardMarkup): TTelegaMessage;
var
  Parameters: TDictionary<String, TValue>;
begin
  Parameters := TDictionary<String, TValue>.Create;
  try
    Parameters.Add('chat_id', chat_id);
    Parameters.Add('text', text);
    Parameters.Add('parse_mode', ToModeString(ParseMode));
    Parameters.Add('disable_web_page_preview', disableWebPagePreview);
    Parameters.Add('disable_notification', disable_notification);
    Parameters.Add('reply_to_message_id', replyToMessageId);
    Parameters.Add('reply_markup', replyMarkup);
    Result := API<TTelegaMessage>('sendMessage', Parameters);
  finally
    Parameters.Free;
  end;
end;

function TTelegramBot.sendVenue(chat_id: TValue; venue: TTelegaVenue; disable_notification: Boolean;
  reply_to_message_id: Integer; reply_markup: TTelegaReplyKeyboardMarkup): TTelegaMessage;
var
  Parameters: TDictionary<String, TValue>;
begin
  Parameters := TDictionary<String, TValue>.Create;
  try
    Parameters.Add('chat_id', chat_id);
    Parameters.Add('latitude', venue.Location.Latitude);
    Parameters.Add('longitude', venue.Location.Longitude);
    Parameters.Add('title', venue.title);
    Parameters.Add('address', venue.Address);
    Parameters.Add('foursquare_id', venue.FoursquareId);
    Parameters.Add('disable_notification', disable_notification);
    Parameters.Add('reply_to_message_id', reply_to_message_id);
    Parameters.Add('reply_markup', reply_markup);
    Result := API<TTelegaMessage>('sendVenue', Parameters);
  finally
    Parameters.Free;
  end;
end;

function TTelegramBot.sendVideo(chat_id, video: TValue; duration, width, height: Integer;
  caption: String; disable_notification: Boolean; reply_to_message_id: Integer;
  reply_markup: TTelegaReplyKeyboardMarkup): TTelegaMessage;
var
  Parameters: TDictionary<String, TValue>;
begin
  Parameters := TDictionary<String, TValue>.Create;
  try
    Parameters.Add('chat_id', chat_id);
    Parameters.Add('video', video);
    Parameters.Add('duration', duration);
    Parameters.Add('width', width);
    Parameters.Add('height', height);
    Parameters.Add('caption', caption);
    Parameters.Add('disable_notification', disable_notification);
    Parameters.Add('reply_to_message_id', reply_to_message_id);
    Parameters.Add('reply_markup', reply_markup);
    Result := API<TTelegaMessage>('sendVideo', Parameters);
  finally
    Parameters.Free;
  end;
end;

function TTelegramBot.sendVoice(chat_id, voice: TValue; duration: Integer;
  disable_notification: Boolean; reply_to_message_id: Integer;
  reply_markup: TTelegaReplyKeyboardMarkup): TTelegaMessage;
var
  Parameters: TDictionary<String, TValue>;
begin
  Parameters := TDictionary<String, TValue>.Create;
  try
    Parameters.Add('chat_id', chat_id);
    Parameters.Add('voice', voice);
    Parameters.Add('duration', duration);
    Parameters.Add('disable_notification', disable_notification);
    Parameters.Add('reply_to_message_id', reply_to_message_id);
    Parameters.Add('reply_markup', reply_markup);
    Result := API<TTelegaMessage>('sendVoice', Parameters);
  finally
    Parameters.Free;
  end;

end;

procedure TTelegramBot.SetIsReceiving(const Value: Boolean);
var
  Task: ITask;
begin
  FIsReceiving := Value;
  if (NOT Assigned(OnUpdate)) or (NOT FIsReceiving) then
    Exit;
  Task := TTask.Create(
    procedure
    var
      LUpdates: TArray<TTelegaUpdate>;

    Begin
      while FIsReceiving do
      Begin
        Sleep(PollingTimeout);
        LUpdates := getUpdates(MessageOffset, 100, PollingTimeout);
        TThread.Synchronize(nil,
          procedure
          var
            Update: TTelegaUpdate;
            PoolUpd: TTelegaBotOnUpdate;
          begin
            for Update in LUpdates do
            begin
              OnUpdate(Self, Update);
              if FUpdatePool.Count > 0 then
                for PoolUpd in FUpdatePool do
                begin
                  PoolUpd(Self, Update);
                end;

              MessageOffset := Update.Id + 1;
            end;
          end);
      end;
    end);
  Task.Start;
end;

function TTelegramBot.unbanChatMember(chat_id: TValue; user_id: Integer): Boolean;
var
  Parameters: TDictionary<String, TValue>;
begin
  Parameters := TDictionary<String, TValue>.Create;
  try
    Parameters.Add('chat_id', chat_id);
    Parameters.Add('user_id', user_id);
    Result := API<Boolean>('unbanChatMember', Parameters);
  finally
    Parameters.Free;
  end;
end;

end.
